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

variable "admin_subnet" {

}

locals {
  prefix = var.prefix
  vm_name = "${local.prefix}-consul-server"
}

resource "azurerm_network_security_group" "default" {  
	name                = "ConsulNSG"
    location            = var.resource_group.location
    resource_group_name = var.resource_group.name

	security_rule {
    name                       = "rpc-tcp-only"
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
    name                       = "lan-tcp"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8301"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

	security_rule {
    name                       = "lan-udp"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "8301"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

	security_rule {
    name                       = "wan-tcp"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8302"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
	
	security_rule {
    name                       = "wan-udp"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "8302"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

	security_rule {
    name                       = "http-tcp-only"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8500"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

	security_rule {
    name                       = "dns-tcp"
    priority                   = 106
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8600"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

	security_rule {
    name                       = "dns-udp"
    priority                   = 107
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "8600"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "admin-ssh"
    priority                   = 200
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
    priority                   = 201
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
  name                = "${local.prefix}-consul-server-lb"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  sku = "Standard"

  frontend_ip_configuration {
    name      = "Primary"
    subnet_id = var.subnet_id
  }
}

resource "azurerm_lb_rule" "rpc-tcp-only" {
  name                           = "rpc-tcp-only"
  resource_group_name            = var.resource_group.name
  loadbalancer_id                = azurerm_lb.default.id
  protocol                       = "Tcp"
  frontend_port                  = 8300
  backend_port                   = 8300
  frontend_ip_configuration_name = "Primary"
}

resource "azurerm_lb_rule" "lan-tcp" {
  name                           = "lan-tcp"
  resource_group_name            = var.resource_group.name
  loadbalancer_id                = azurerm_lb.default.id
  protocol                       = "Tcp"
  frontend_port                  = 8301
  backend_port                   = 8301
  frontend_ip_configuration_name = "Primary"
}

resource "azurerm_lb_rule" "lan-udp" {
  name                           = "lan-udp"
  resource_group_name            = var.resource_group.name
  loadbalancer_id                = azurerm_lb.default.id
  protocol                       = "Udp"
  frontend_port                  = 8301
  backend_port                   = 8301
  frontend_ip_configuration_name = "Primary"
}

resource "azurerm_lb_rule" "wan-tcp" {
  name                           = "wan-tcp"
  resource_group_name            = var.resource_group.name
  loadbalancer_id                = azurerm_lb.default.id
  protocol                       = "Tcp"
  frontend_port                  = 8302
  backend_port                   = 8302
  frontend_ip_configuration_name = "Primary"
}

resource "azurerm_lb_rule" "wan-udp" {
  name                           = "wan-udp"
  resource_group_name            = var.resource_group.name
  loadbalancer_id                = azurerm_lb.default.id
  protocol                       = "Udp"
  frontend_port                  = 8302
  backend_port                   = 8302
  frontend_ip_configuration_name = "Primary"
}

resource "azurerm_lb_rule" "http-tcp-only" {
  name                           = "http-tcp-only"
  resource_group_name            = var.resource_group.name
  loadbalancer_id                = azurerm_lb.default.id
  protocol                       = "Tcp"
  frontend_port                  = 8500
  backend_port                   = 8500
  frontend_ip_configuration_name = "Primary"
}

resource "azurerm_lb_rule" "dns-tcp" {
  name                           = "dns-tcp"
  resource_group_name            = var.resource_group.name
  loadbalancer_id                = azurerm_lb.default.id
  protocol                       = "Tcp"
  frontend_port                  = 8600
  backend_port                   = 8600
  frontend_ip_configuration_name = "Primary"
}

resource "azurerm_lb_rule" "dns-udp" {
  name                           = "dns-udp"
  resource_group_name            = var.resource_group.name
  loadbalancer_id                = azurerm_lb.default.id
  protocol                       = "Udp"
  frontend_port                  = 8600
  backend_port                   = 8600
  frontend_ip_configuration_name = "Primary"
}

resource "azurerm_lb_backend_address_pool" "default" {
  loadbalancer_id = azurerm_lb.default.id
  name            = "ConsulBackEndAddressPool"
}

resource "azurerm_linux_virtual_machine_scale_set" "default" {
	name                = "${local.vm_name}-vmss"
	resource_group_name = var.resource_group.name
	location            = var.resource_group.location
	sku                = var.vm_size
	instances = var.vm_instances
	admin_username      = var.admin_username

	custom_data = base64encode(
		templatefile("${path.module}/config/cloud-init.yaml", 
		{ 
      ssh_pub_key = var.ssh_key
		}
	))
	
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
			load_balancer_backend_address_pool_ids = [
				azurerm_lb_backend_address_pool.default.id
			]
    }
  }
}


output "lb" {
	value = azurerm_lb.default
}