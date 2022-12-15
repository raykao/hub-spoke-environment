resource "azurerm_network_interface" "example" {
  name                = "${local.hostname}-nic"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_network_security_group" "example" {
  
	name                = "${local.hostname}-nsg"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  security_rule {
		name                       = "AllowRDPInbound3389"
    description = null
		priority                   = 100
		direction                  = "Inbound"
		access                     = "Allow"
		protocol                   = "Tcp"
		source_port_range          = "*"
		destination_port_range     = "3389"
		source_address_prefix      = "VirtualNetwork"
		destination_address_prefix = "VirtualNetwork"
	}
}

resource "azurerm_network_interface_security_group_association" "example" {
	network_interface_id                 = azurerm_windows_virtual_machine.example.network_interface_ids[0]
	network_security_group_id 			     = azurerm_network_security_group.example.id
}

resource "azurerm_windows_virtual_machine" "example" {
  name                = local.hostname
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  size                = var.sku
  admin_username      = var.admin_username
  admin_password      = local.admin_password
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]
  
  vtpm_enabled = false

  allow_extension_operations = true

  enable_automatic_updates = true

  os_disk {
    caching              = var.caching
    storage_account_type = var.storage_account_type
    disk_size_gb = var.disk_size_gb
  }

  source_image_reference {
    offer     = "windows-11"
    publisher = "microsoftwindowsdesktop"
    sku       = "win11-21h2-pro"
    version   = "latest"
  }

  identity {
   type = "SystemAssigned"  
  }

  license_type = "Windows_Client"
}


## AAD login seesm broke at the moment with MSFT AAD
# resource "azurerm_virtual_machine_extension" "aad" {
#   name                 = "AADLoginForWindows"
#   virtual_machine_id   = azurerm_windows_virtual_machine.example.id
#   publisher            = "Microsoft.Azure.ActiveDirectory"
#   type                 = "AADLoginForWindows"
#   type_handler_version = "1.0"

#   settings = jsonencode({
#     mdmId = ""
#   })
# }

# resource "azurerm_role_assignment" "vmAdminLogin" {
#   scope = azurerm_windows_virtual_machine.example.id
#   role_definition_name = "Virtual Machine Administrator Login"
#   principal_id = local.current_user
# }

resource "azurerm_role_assignment" "jumpbox-contributor" {
  scope                = var.resource_group.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_windows_virtual_machine.example.identity[0].principal_id
}