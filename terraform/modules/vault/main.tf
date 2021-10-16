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
  default = "Standard_F2s_v2"
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

variable "storage_account" {
}

variable "tenant_id" {
  type = string
  default = ""
}

variable "pgsql_private_dns_zone_id" {
  type = string
}

data "azurerm_client_config" "current" {}

locals {
  prefix = var.prefix
  vm_name = "${local.prefix}-vault-server"
  tenant_id = var.tenant_id != "" ? var.tenant_id : data.azurerm_client_config.current.tenant_id
  postgres_admin_username = var.postgres_admin_username != "" ? var.postgres_admin_username : "vaultadmin"
  postgres_admin_password = var.postgres_admin_password != "" ? var.postgres_admin_password : random_password.postgres.result
}

terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
    }
  }
}

resource "random_password" "postgres" {
  length           = 16
  special          = true
  override_special = "_%@"

}

resource "random_id" "encrpyt_key" {
  byte_length = 32
}


resource "azurerm_postgresql_server" "vault" {
  name                = "${local.prefix}-vault-psqlserver"
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

resource "azurerm_postgresql_database" "vault" {
  name                = "vault"
  resource_group_name = var.resource_group.name
  server_name         = azurerm_postgresql_server.vault.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_private_endpoint" "pgsql" {
	name = "${local.prefix}-pe-vault-pgsql-hub"
	location = var.resource_group.location
	resource_group_name = var.resource_group.name
	subnet_id = var.subnet_id

  private_service_connection {
    name = "${local.prefix}vault-privateserviceconnection"
    is_manual_connection = false
    private_connection_resource_id = azurerm_postgresql_server.vault.id
    subresource_names = ["postgresqlServer"]
  }

   private_dns_zone_group {
    name                  = "pgsql-dns-group"
    private_dns_zone_ids  = [ var.pgsql_private_dns_zone_id ]
  }
}

resource "azurerm_user_assigned_identity" "vault" {
  name                = "${local.prefix}-identity"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
}

resource "azurerm_role_assignment" "msi_azure_storage_backend" {
  scope                = var.storage_account.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.vault.principal_id
}

resource "azurerm_role_assignment" "msi_akv" {
  scope                = azurerm_key_vault.default.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.vault.principal_id
}

resource "azurerm_role_assignment" "msi_postgres_ha_backend" {
  scope                = azurerm_postgresql_server.vault.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.vault.principal_id
}

resource "azurerm_key_vault" "default" {
	
	name                = "${local.prefix}vaultkeyvault"
	location            = var.resource_group.location
	resource_group_name = var.resource_group.name
	tenant_id           = local.tenant_id
	sku_name            = "premium"
}

resource "azurerm_key_vault_access_policy" "vault" {
	
	key_vault_id = azurerm_key_vault.default.id
	tenant_id    = local.tenant_id
	object_id    = azurerm_user_assigned_identity.vault.principal_id
  
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

resource "azurerm_network_security_group" "default" {  
	name                = "vaultNSG"
    location            = var.resource_group.location
    resource_group_name = var.resource_group.name

	security_rule {
    name                       = "vault-server-tcp-only"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8300"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

	security_rule {
    name                       = "vault-client-tcp-only"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8301"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "admin-ssh"
    priority                   = 190
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.admin_subnet.address_prefixes[0]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "ssh-deny"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "internet-outbound-allow"
    priority                   = 500
    direction                  = "Outbound"
    access                     = "allow"
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
  name                = "${local.prefix}-vault-server-lb"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  sku = "Standard"

  frontend_ip_configuration {
    name      = "Primary"
    subnet_id = var.subnet_id
  }
}

resource "azurerm_lb_rule" "vault-server-tcp-only" {
  name                           = "vault-server-tcp-only"
  resource_group_name            = var.resource_group.name
  loadbalancer_id                = azurerm_lb.default.id
  protocol                       = "Tcp"
  frontend_port                  = 8200
  backend_port                   = 8200
  frontend_ip_configuration_name = "Primary"
}

resource "azurerm_lb_rule" "lan-tcp" {
  name                           = "vault-client-tcp-only"
  resource_group_name            = var.resource_group.name
  loadbalancer_id                = azurerm_lb.default.id
  protocol                       = "Tcp"
  frontend_port                  = 8201
  backend_port                   = 8201
  frontend_ip_configuration_name = "Primary"
}

resource "azurerm_lb_backend_address_pool" "default" {
  loadbalancer_id = azurerm_lb.default.id
  name            = "vaultBackEndAddressPool"
}

resource "azurerm_linux_virtual_machine_scale_set" "default" {
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
      vault_name = azurerm_key_vault.default.name
      key_name = "vault"

      postgres_admin_username = local.postgres_admin_username
      postgres_admin_password = local.postgres_admin_password
      postgres_host           = azurerm_postgresql_server.vault.fqdn
		}
	))
	
	identity {
		type = "UserAssigned"
		identity_ids = [
      azurerm_user_assigned_identity.vault.id
    ]
	}

	admin_ssh_key {
		username   = var.admin_username
		public_key = var.ssh_key
	}

	os_disk {
		caching              	= "ReadOnly"
		storage_account_type 	= "Premium_LRS"
		disk_size_gb 			= "100"
	}

  data_disk {
    lun = 0
    disk_size_gb = 20
    caching = "ReadOnly"
    storage_account_type = "StandardSSD_LRS"
  }

	source_image_reference {
		publisher = "Canonical"
		offer     = "0001-com-ubuntu-server-focal"
		sku       = "20_04-lts-gen2"
		version   = "20.04.202109080"
	}

	network_interface {
    name    = "primary"
    primary = true
		enable_accelerated_networking = false

    ip_configuration {
      name      = "primary"
      primary   = true
      subnet_id = var.subnet_id
			load_balancer_backend_address_pool_ids = [
				azurerm_lb_backend_address_pool.default.id
			]
    }
  }
}


output "lb" {
	value = azurerm_lb.default
}