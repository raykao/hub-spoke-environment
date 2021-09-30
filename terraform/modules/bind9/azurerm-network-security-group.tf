
resource "azurerm_network_security_group" "dns" {
  	# provider = azurerm.sub

	name                = "dnsNSG"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

	security_rule {
    name                       = "allowVnetDnsInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

	security_rule {
    name                       = "allowSshVnetInbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.admin_subnet_prefix
    destination_address_prefix = "*"
  }

	security_rule {
    name                       = "denyAllInbound"
    priority                   = 500
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "example" {
	# provider = azurerm.sub
	subnet_id                 = var.subnet_id
	network_security_group_id = azurerm_network_security_group.dns.id
}