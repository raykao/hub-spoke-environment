terraform {
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"
			version = "~> 2.78.0"
		}
	}
}

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
	default = "Standard_D2s_v3"
}

variable "admin_username" {
	type = string
}

variable "ssh_key" {
	type = string
}

variable userMSI {
	type = string
	default = ""
}

variable "admin_email" {
	type = string
}

variable "index" {
	type = string
	default = ""
}

resource "random_string" "suffix" {
	length  = 4
	special = false
	number 	= false
	upper 	= false
}

locals {
	prefix = "${var.prefix}"
	index = var.index != "" ? var.index : random_string.suffix.result
}

data "http" "myip" {
  url = "https://api.ipify.org/"
}

resource "azurerm_public_ip" "jumpbox" {
	name                = "${local.prefix}jumpbox${local.index}-pip"
	resource_group_name = var.resource_group.name
	location            = var.resource_group.location
	allocation_method   = "Static"
	sku 				= "Standard"
  	domain_name_label = "${local.prefix}jumpbox${local.index}"
}

resource "azurerm_network_interface" "jumpbox" {
	name                = "${local.prefix}jumpbox${local.index}-nic"
	location            = var.resource_group.location
	resource_group_name = var.resource_group.name

	enable_accelerated_networking = true
	
	ip_configuration {
		name                          = "primary"
		subnet_id                     = var.subnet_id
		private_ip_address_allocation = "Dynamic"
		public_ip_address_id  = azurerm_public_ip.jumpbox.id
	}
}

resource "azurerm_network_security_group" "jumpbox" {
  
	name                = "JumpboxNSG"
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
    source_address_prefix      = "${chomp(data.http.myip.body)}/32"
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
    source_address_prefix      = "${chomp(data.http.myip.body)}/32"
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

resource "azurerm_subnet_network_security_group_association" "jumpbox" {
	subnet_id                 = var.subnet_id
	network_security_group_id = azurerm_network_security_group.jumpbox.id
}

resource "azurerm_linux_virtual_machine" "jumpbox" {
	name                = "${local.prefix}jumpbox${local.index}"
	resource_group_name = var.resource_group.name
	location            = var.resource_group.location
	size                = var.vm_size
	admin_username      = var.admin_username
	custom_data = base64encode(
		templatefile("${path.module}/config/jumpbox-cloud-init.yaml", 
		{ 
			admin_username = var.admin_username
			url = azurerm_public_ip.jumpbox.fqdn
			admin_email = var.admin_email
			terraform_version = "1.0.7"
		}
	))

	network_interface_ids = [
		azurerm_network_interface.jumpbox.id,
	]

	identity {
		type = var.userMSI == "" ? "SystemAssigned" : "UserAssigned"
		identity_ids = var.userMSI == "" ? [] : [
			var.userMSI
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

	lifecycle {
		ignore_changes = [
			custom_data
		]
  }
}

output ip {
	value = azurerm_public_ip.jumpbox.ip_address
}

output fqdn {
	value = azurerm_public_ip.jumpbox.fqdn
}