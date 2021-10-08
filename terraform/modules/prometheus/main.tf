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
  default = "Standard_F4s_v2"
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

variable "user_msi" {
  type = string
  default = ""
}

locals {
  prefix = var.prefix
  vm_name = "${local.prefix}-prom-server"
}

resource "azurerm_network_security_group" "default" {  
	name                = "PrometheusNSG"
    location            = var.resource_group.location
    resource_group_name = var.resource_group.name
}

resource "azurerm_subnet_network_security_group_association" "default" {
	subnet_id                 = var.subnet_id
	network_security_group_id = azurerm_network_security_group.default.id
}

resource "azurerm_linux_virtual_machine_scale_set" "default" {
	name                = "${local.vm_name}-vmss"
	resource_group_name = var.resource_group.name
	location            = var.resource_group.location
	sku                = var.vm_size
	instances = var.vm_instances
	admin_username      = var.admin_username

	# custom_data = base64encode(
	# 	templatefile("${path.module}/config/cloud-init.yaml", 
	# 	{ 
	# 		admin_username = var.admin_username
	# 		url = azurerm_public_ip.default.fqdn
	# 		admin_email = var.admin_email
	# 		terraform_version = "1.0.7"
	# 	}
	# ))
	
	identity {
		type = var.user_msi == "" ? "SystemAssigned" : "UserAssigned"
		identity_ids = var.user_msi == "" ? [] : [
			var.user_msi
		]	
	}

	admin_ssh_key {
		username   = var.admin_username
		public_key = var.ssh_key
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

	network_interface {
    name    = "primary"
    primary = true
		enable_accelerated_networking = true

    ip_configuration {
      name      = "primary"
      primary   = true
      subnet_id = var.subnet_id
    }
  }
}