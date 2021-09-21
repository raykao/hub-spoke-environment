resource "azurerm_resource_group" "hub" {
	provider = azurerm.sub1
  	name = "${local.prefix}hub-rg"
  	location = local.location
}

resource "azurerm_virtual_network" "hub" {
	provider = azurerm.sub1
	name = "${local.prefix}hub-vnet"
	resource_group_name = azurerm_resource_group.hub.name
	location = azurerm_resource_group.hub.location
	address_space       = [var.hub_address_space]
}

resource azurerm_subnet firewall {
	provider = azurerm.sub1
	name = "AzureFirewall"
	resource_group_name  = azurerm_resource_group.hub.name
	virtual_network_name = azurerm_virtual_network.hub.name
	address_prefixes     = [cidrsubnet(azurerm_virtual_network.hub.address_space[0], 10, 0)]
}

resource azurerm_subnet vpn {
	provider = azurerm.sub1
	name = "VpnGateway"
	resource_group_name  = azurerm_resource_group.hub.name
	virtual_network_name = azurerm_virtual_network.hub.name
	address_prefixes     = [cidrsubnet(azurerm_virtual_network.hub.address_space[0], 8, 1)]
}

resource azurerm_subnet jumpbox {
	provider = azurerm.sub1
	name = "JumpboxSubnet"
	resource_group_name  = azurerm_resource_group.hub.name
	virtual_network_name = azurerm_virtual_network.hub.name
	address_prefixes     = [cidrsubnet(azurerm_virtual_network.hub.address_space[0], 8, 255)]
}

resource "azurerm_virtual_network_peering" "hubtospoke1" {
	provider = azurerm.sub1
	name                      = "hubtospoke1"
	resource_group_name       = azurerm_resource_group.hub.name
	virtual_network_name      = azurerm_virtual_network.hub.name
	remote_virtual_network_id = azurerm_virtual_network.spoke1.id
}

resource "azurerm_virtual_network_peering" "hubtospoke2" {
	provider = azurerm.sub1
	name                      = "hubtospoke2"
	resource_group_name       = azurerm_resource_group.hub.name
	virtual_network_name      = azurerm_virtual_network.hub.name
	remote_virtual_network_id = azurerm_virtual_network.spoke2.id
}

resource "azurerm_user_assigned_identity" "jumpbox" {
	provider = azurerm.sub1
	resource_group_name = azurerm_resource_group.hub.name
	location            = azurerm_resource_group.hub.location

	name = "${var.prefix}-jumpbox-user-msi"
}

resource "azurerm_role_assignment" "hub" {
	provider = azurerm.sub1
	scope                = azurerm_resource_group.hub.id
	role_definition_name = "Contributor"
	principal_id         = azurerm_user_assigned_identity.jumpbox.principal_id
}

resource "azurerm_role_assignment" "spoke1" {
  	provider = azurerm.sub1
	scope                = azurerm_resource_group.spoke1.id
	role_definition_name = "Contributor"
	principal_id         = azurerm_user_assigned_identity.jumpbox.principal_id
}

resource "azurerm_role_assignment" "spoke2" {
  	provider = azurerm.sub1
	scope                = azurerm_resource_group.spoke2.id
	role_definition_name = "Contributor"
	principal_id         = azurerm_user_assigned_identity.jumpbox.principal_id
}

resource "azurerm_public_ip" "jumpbox" {
	provider = azurerm.sub1
	name                = "${var.prefix}jumpbox-pip"
	resource_group_name = azurerm_resource_group.hub.name
	location            = azurerm_resource_group.hub.location
	allocation_method   = "Static"
	sku 				= "Standard"
  	domain_name_label = "${var.prefix}jumpbox"
}

resource "azurerm_network_interface" "jumpbox" {
	provider = azurerm.sub1
	name                = "${var.prefix}jumpbox-nic"
	location            = azurerm_resource_group.hub.location
	resource_group_name = azurerm_resource_group.hub.name

	enable_accelerated_networking = true
	
	ip_configuration {
		name                          = "primary"
		subnet_id                     = azurerm_subnet.jumpbox.id
		private_ip_address_allocation = "Dynamic"
		public_ip_address_id  = azurerm_public_ip.jumpbox.id
	}
}

resource "azurerm_network_security_group" "jumpbox" {
  	provider = azurerm.sub1

	name                = "JumpboxNSG"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  security_rule {
    name                       = "AllowSSHInbound2202"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "2022"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowEverythingOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyInboundOMIGod"
    priority                   = 500
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "5986"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "example" {
  	provider = azurerm.sub1
	subnet_id                 = azurerm_subnet.jumpbox.id
  	network_security_group_id = azurerm_network_security_group.jumpbox.id
}

resource "azurerm_linux_virtual_machine" "jumpbox" {
	provider = azurerm.sub1
	name                = "${var.prefix}jumpbox"
	resource_group_name = azurerm_resource_group.hub.name
	location            = azurerm_resource_group.hub.location
	size                = "Standard_D16s_v3"
	admin_username      = local.admin_username
	custom_data = base64encode(templatefile("${path.module}/config/jumpbox-cloud-init.yaml", {}))

	network_interface_ids = [
		azurerm_network_interface.jumpbox.id,
	]

	identity {
		type = "UserAssigned"
		identity_ids = [
			azurerm_user_assigned_identity.jumpbox.id
		]	
	}

	admin_ssh_key {
		username   = local.admin_username
		public_key = file("~/.ssh/id_rsa.pub")
	}

	os_disk {
		caching              	= "ReadOnly"
		storage_account_type 	= "Premium_LRS"
		disk_size_gb 			= "1024"
	}

	source_image_reference {
		publisher = "Canonical"
		offer     = "0001-com-ubuntu-server-focal"
		sku       = "20_04-lts-gen2"
		version   = "20.04.202109080"
	}

	lifecycle {
		ignore_changes = [
		custom_data,
		]
  }
}

resource "azurerm_dns_zone" "prod" {
	provider = azurerm.sub1
	name                = "prod.${var.domain}"
	resource_group_name = azurerm_resource_group.hub.name
}

resource "azurerm_dns_cname_record" "jumpbox" {
  provider = azurerm.sub1
  name                = "jumpbox"
  zone_name           = azurerm_dns_zone.prod.name
  resource_group_name = azurerm_resource_group.hub.name
  ttl                 = 60
  record              = azurerm_public_ip.jumpbox.fqdn
}

resource "azurerm_dns_zone" "dev" {
	provider = azurerm.sub1
  name                = "dev.${var.domain}"
  resource_group_name = azurerm_resource_group.hub.name
}

resource "azurerm_traffic_manager_profile" "global" {
	provider = azurerm.sub1
  name                   = "${var.prefix}-hub-prod"
  resource_group_name    = azurerm_resource_group.hub.name
  traffic_routing_method = "Performance"

  dns_config {
    relative_name = "${var.prefix}-hub-prod"
    ttl           = 60
  }

  monitor_config {
    protocol                     = "http"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }
}