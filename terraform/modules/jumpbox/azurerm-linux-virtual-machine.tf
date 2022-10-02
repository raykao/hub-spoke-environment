
resource "azurerm_network_interface" "jumpbox" {
	name                = "${local.name}-nic"
	location            = var.resource_group.location
	resource_group_name = var.resource_group.name

	enable_accelerated_networking = true
	
	ip_configuration {
		name                          = "primary"
		subnet_id                     = var.subnet_id
		private_ip_address_allocation = "Dynamic"
		# public_ip_address_id  = azurerm_public_ip.jumpbox.id
	}
}

resource "azurerm_network_security_group" "jumpbox" {
  
	name                = "${local.name}-nsg"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  security_rule {
    name                       = "AllowSSHInbound2202"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "2022"
    source_address_prefix      = "${chomp(local.myip)}/32"
    destination_address_prefix = "*"
  }

	security_rule {
    name                       = "AllowRDPInbound2023"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "2023"
    source_address_prefix      = "${chomp(local.myip)}/32"
    destination_address_prefix = "*"
  }

	security_rule {
    name                       = "AllowHttpInternetInbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

	security_rule {
    name                       = "AllowHttpsInternetInbound"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "jumpbox" {
	network_interface_id                 = azurerm_linux_virtual_machine.jumpbox.network_interface_ids[0]
	network_security_group_id 			 = azurerm_network_security_group.jumpbox.id
}

resource "azurerm_linux_virtual_machine" "jumpbox" {
	name                = local.name
	resource_group_name = var.resource_group.name
	location            = var.resource_group.location
	size                = var.vm_size
	admin_username      = local.admin_username
	custom_data = base64encode(
		templatefile("${path.module}/config/jumpbox-cloud-init.yaml", 
		{ 
			admin_username = local.admin_username
			# url = azurerm_public_ip.jumpbox.fqdn
			admin_email = local.admin_email
			terraform_version = "1.0.7"
		}
	))

	network_interface_ids = [
		azurerm_network_interface.jumpbox.id,
	]

	identity {
		type = "SystemAssigned"
	}

	admin_ssh_key {
		username   = local.admin_username
		public_key = local.public_key
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
			custom_data
		]
  }
}