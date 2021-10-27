variable "prefix" {
  type = string
}

variable "resource_group" {
}

variable "subnet_id" {
  type = string
}

variable "vm_size" {
  type = string
  default = "Standard_DS2_v2"
}

variable "vm_instances" {
	type = number
	default = 1
}

variable "admin_username" {
}

variable "ssh_key" {
	type = string
}

variable "postgres_admin_username" {
  type = string
  default = ""
}
variable postgres_admin_password {
  type = string
  default = ""
}

variable "domain" {
  type = string
}

variable "admin_subnet" {

}

variable "tenant_id" {
  type = string
  default = ""
}

variable "pgsql_private_dns_zone_id" {
  type = string
}

variable "keyvault_private_dns_zone_id" {
  type = string
}

data "azurerm_client_config" "current" {}

locals {
  prefix = var.prefix
  vm_name = "${local.prefix}-stepca-server"
  tenant_id = var.tenant_id != "" ? var.tenant_id : data.azurerm_client_config.current.tenant_id
  postgres_admin_username = var.postgres_admin_username != "" ? var.postgres_admin_username : "stepcaadmin"
  postgres_admin_password = var.postgres_admin_password != "" ? var.postgres_admin_password : random_password.postgres.result
  systemd = base64encode(file("${path.module}/config/stepca.service"))
  step_config = base64encode(templatefile("${path.module}/config/ca.json", {
    key_name = azurerm_key_vault_certificate.intermediate-ca.name
    vault_name = azurerm_key_vault.default.name
    certificate_version = azurerm_key_vault_certificate.intermediate-ca.version
    dns_name = azurerm_private_dns_a_record.stepca.fqdn
    hsm = local.hsm
  }))
  root_ca = azurerm_key_vault_certificate.intermediate-ca.certificate_data_base64
  hsm = false
  # run_script = base64encode(file("${path.module}/config/run.sh"))

}

terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
    }
  }
}

resource "random_password" "postgres" {
  length           = 32
  min_numeric      = 4
  min_upper        = 4
  special          = true
  override_special = "_%@"

}

resource "random_id" "encrpyt_key" {
  byte_length = 32
}

resource "azurerm_postgresql_server" "stepca" {
  name                = "${local.prefix}-stepca-psqlserver"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  administrator_login          = local.postgres_admin_username
  administrator_login_password = local.postgres_admin_password

  sku_name   = "GP_Gen5_2"
  version    = "11"
  storage_mb = 65536

  # backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = false

  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

resource "azurerm_postgresql_database" "stepca" {
  name                = "stepca"
  resource_group_name = var.resource_group.name
  server_name         = azurerm_postgresql_server.stepca.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "time_sleep" "destroy_wait_30_seconds" {
  depends_on = [azurerm_postgresql_database.stepca]

  destroy_duration = "30s"
}

resource "azurerm_private_endpoint" "pgsql" {
	name = "${local.prefix}-pe-stepca-pgsql-hub"
	location = var.resource_group.location
	resource_group_name = var.resource_group.name
	subnet_id = var.subnet_id

  private_service_connection {
    name = "${local.prefix}stepca-pgsql-privateserviceconnection"
    is_manual_connection = false
    private_connection_resource_id = azurerm_postgresql_server.stepca.id
    subresource_names = ["postgresqlServer"]
  }

   private_dns_zone_group {
    name                  = "pgsql-dns-group"
    private_dns_zone_ids  = [ var.pgsql_private_dns_zone_id ]
  }
}

resource "azurerm_private_endpoint" "keyvault" {
	name = "${local.prefix}-pe-stepca-keyvault-hub"
	location = var.resource_group.location
	resource_group_name = var.resource_group.name
	subnet_id = var.subnet_id

  private_service_connection {
    name = "${local.prefix}stepca-keyvault-privateserviceconnection"
    is_manual_connection = false
    private_connection_resource_id = azurerm_key_vault.default.id
    subresource_names = ["vault"]
  }

   private_dns_zone_group {
    name                  = "keyvault-dns-group"
    private_dns_zone_ids  = [ var.keyvault_private_dns_zone_id ]
  }
}

resource "azurerm_user_assigned_identity" "stepca" {
  name                = "${local.prefix}-stepca-identity"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
}

resource "azurerm_role_assignment" "msi_akv" {
  scope                = azurerm_key_vault.default.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.stepca.principal_id
}

resource "azurerm_role_assignment" "msi_postgres_ha_backend" {
  scope                = azurerm_postgresql_server.stepca.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.stepca.principal_id
}

resource "azurerm_key_vault" "default" {
	
	name                = "${local.prefix}stepcakeyvault"
	location            = var.resource_group.location
	resource_group_name = var.resource_group.name
	tenant_id           = local.tenant_id
	sku_name            = "premium"
}

resource "azurerm_key_vault_access_policy" "stepca" {
	key_vault_id = azurerm_key_vault.default.id
	tenant_id    = local.tenant_id
	object_id    = azurerm_user_assigned_identity.stepca.principal_id
  
	certificate_permissions = [
		"Backup",
		"Create",
		"Delete",
		"DeleteIssuers",
		"Get",
		"GetIssuers",
		"Import",
		"List",
		"ListIssuers",
		"ManageContacts",
		"ManageIssuers",
		"Purge",
		"Recover",
		"Restore",
		"SetIssuers",
		"Update"
	]

	key_permissions = [
		"Backup",
		"Create",
		"Decrypt",
		"Delete",
		"Encrypt",
		"Get",
		"Import",
		"List",
		"Purge",
		"Recover",
		"Restore",
		"Sign",
		"UnwrapKey",
		"Update",
		"Verify",
		"WrapKey"
	]

	secret_permissions = [
		"Backup",
		"Delete",
		"Get",
		"List",
		"Purge",
		"Recover",
		"Restore",
		"Set"
	]
}


resource "azurerm_key_vault_access_policy" "admin" {
	key_vault_id = azurerm_key_vault.default.id
	tenant_id    = local.tenant_id
	object_id    = data.azurerm_client_config.current.object_id
  
	certificate_permissions = [
		"Backup",
		"Create",
		"Delete",
		"DeleteIssuers",
		"Get",
		"GetIssuers",
		"Import",
		"List",
		"ListIssuers",
		"ManageContacts",
		"ManageIssuers",
		"Purge",
		"Recover",
		"Restore",
		"SetIssuers",
		"Update"
	]

	key_permissions = [
		"Backup",
		"Create",
		"Decrypt",
		"Delete",
		"Encrypt",
		"Get",
		"Import",
		"List",
		"Purge",
		"Recover",
		"Restore",
		"Sign",
		"UnwrapKey",
		"Update",
		"Verify",
		"WrapKey"
	]

	secret_permissions = [
		"Backup",
		"Delete",
		"Get",
		"List",
		"Purge",
		"Recover",
		"Restore",
		"Set"
	]
}

resource "azurerm_key_vault_certificate" "intermediate-ca" {
  depends_on = [
    azurerm_key_vault_access_policy.admin
  ]

  name         = "intermediate-ca"
  key_vault_id = azurerm_key_vault.default.id

  certificate_policy {
    issuer_parameters {
      name = "Unknown"
    }

    key_properties {
      exportable = true
      key_size   = 256
      key_type   = "EC"
      reuse_key  = true
      curve = "P-256"
    }

    lifetime_action {
      action {
        action_type = "EmailContacts"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.1", "1.3.6.1.5.5.7.3.2"]

      key_usage = [
        "digitalSignature",
        "cRLSign",
        "keyCertSign",
      ]

      subject_alternative_names {
        dns_names = [azurerm_private_dns_a_record.stepca.fqdn]
      }

      subject            = "CN=${azurerm_private_dns_a_record.stepca.fqdn}"
      validity_in_months = 12
    }

  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      certificate_policy[0].x509_certificate_properties[0].key_usage      ]
  }
}

resource "azurerm_network_security_group" "default" {  
	name                = "stepcaNSG"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
    
  security_rule {
    name                       = "stepca-server-tcp-only"
    priority                   = 100
    description                = ""
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "stepca-client-tcp-only"
    priority                   = 110
    description                = ""
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-admin-all"
    priority                   = 190
    description                = ""
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.admin_subnet.address_prefixes[0]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "ssh-deny"
    priority                   = 200
    description                = ""
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "psql-deny"
    priority                   = 300
    description                = ""
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "internet-outbound-allow"
    priority                   = 500
    description                = ""
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}



resource "azurerm_subnet_network_security_group_association" "default" {
	subnet_id                 = var.subnet_id
	network_security_group_id = azurerm_network_security_group.default.id
}

resource "azurerm_lb" "default" {
  name                = "${local.prefix}-stepca-server-lb"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  sku = "Standard"

  frontend_ip_configuration {
    name      = "Primary"
    subnet_id = var.subnet_id
  }
}

resource "azurerm_lb_probe" "stepca-server" {
  resource_group_name = var.resource_group.name
  loadbalancer_id     = azurerm_lb.default.id
  name                = "stepca-server-http-probe"
  port                = 80
}

resource "azurerm_lb_rule" "stepca-server-http" {
  name                           = "stepca-server-http"
  resource_group_name            = var.resource_group.name
  loadbalancer_id                = azurerm_lb.default.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "Primary"
  backend_address_pool_ids        = [ 
    azurerm_lb_backend_address_pool.default.id 
  ]
  probe_id                       = azurerm_lb_probe.stepca-server.id
}

resource "azurerm_lb_rule" "stepca-server-https" {
  name                           = "stepca-server-https"
  resource_group_name            = var.resource_group.name
  loadbalancer_id                = azurerm_lb.default.id
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "Primary"
  backend_address_pool_ids        = [ 
    azurerm_lb_backend_address_pool.default.id 
  ]
  probe_id                       = azurerm_lb_probe.stepca-server.id
}

resource "azurerm_lb_backend_address_pool" "default" {
  loadbalancer_id = azurerm_lb.default.id
  name            = "stepcaBackEndAddressPool"
}

resource "azurerm_linux_virtual_machine_scale_set" "default" {
  depends_on = [
    time_sleep.destroy_wait_30_seconds
  ]
	name                = "${local.vm_name}-vmss"
	resource_group_name = var.resource_group.name
	location            = var.resource_group.location
	sku                 = var.vm_size
	instances           = var.vm_instances
	admin_username      = var.admin_username

	custom_data = base64encode(
		templatefile("${path.module}/config/cloud-init.yaml", 
		{ 
      ssh_key = trimspace(var.ssh_key)
      tenant_id = local.tenant_id

      systemd = local.systemd

      dns_name = azurerm_private_dns_a_record.stepca.fqdn

      step_config = local.step_config

      # root_ca = azurerm_key_vault_certificate.intermediate-ca.certificate_data_base64
      # run_script              = local.run_script
		}
	))
	
	identity {
		type = "UserAssigned"
		identity_ids = [
      azurerm_user_assigned_identity.stepca.id
    ]
	}

	admin_ssh_key {
		username   = var.admin_username
		public_key = var.ssh_key
	}

	os_disk {
		caching              	= "ReadOnly"
		storage_account_type 	= "Premium_LRS"
		disk_size_gb 			    = "100"
	}

	source_image_reference {
		publisher = "Canonical"
		offer     = "0001-com-ubuntu-server-focal"
		sku       = "20_04-lts-gen2"
		version   = "20.04.202109080"
	}

	network_interface {
    name                          = "primary"
    primary                       = true
		enable_accelerated_networking = false

    ip_configuration {
      name                                    = "primary"
      primary                                 = true
      subnet_id                               = var.subnet_id
			load_balancer_backend_address_pool_ids  = [
				azurerm_lb_backend_address_pool.default.id
			]
    }
  }
}

resource "azurerm_private_dns_a_record" "stepca" {
  name                = "ca"
  zone_name           = var.domain
  resource_group_name = var.resource_group.name
  ttl                 = 60
  records             = [azurerm_lb.default.frontend_ip_configuration[0].private_ip_address]
}

output "lb" {
	value = azurerm_lb.default
}
