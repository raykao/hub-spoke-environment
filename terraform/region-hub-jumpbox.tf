resource "azurerm_user_assigned_identity" "jumpbox" {
	provider = azurerm.sub1
	resource_group_name = azurerm_resource_group.hub.name
	location            = azurerm_resource_group.hub.location

	name = "${local.prefix}-jumpbox-user-msi"
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

resource "azurerm_role_assignment" "spoke3" {
  	provider = azurerm.sub1
	scope                = azurerm_resource_group.spoke3.id
	role_definition_name = "Contributor"
	principal_id         = azurerm_user_assigned_identity.jumpbox.principal_id
}

resource "azurerm_public_ip" "jumpbox" {
	provider = azurerm.sub1
	name                = "${local.prefix}jumpbox-pip"
	resource_group_name = azurerm_resource_group.hub.name
	location            = azurerm_resource_group.hub.location
	allocation_method   = "Static"
	sku 				= "Standard"
  	domain_name_label = "${local.prefix}jumpbox"
}

resource "azurerm_network_interface" "jumpbox" {
	provider = azurerm.sub1
	name                = "${local.prefix}jumpbox-nic"
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
    name                       = "DenySSHInbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
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
	name                = "${local.prefix}jumpbox"
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