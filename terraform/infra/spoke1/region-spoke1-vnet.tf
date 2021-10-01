resource "azurerm_virtual_network" "spoke1" {
	
	name = "${local.prefix}spoke1-vnet"
	resource_group_name = azurerm_resource_group.spoke1.name
	location = azurerm_resource_group.spoke1.location
	address_space       = [var.address_space]
	dns_servers = var.hub.vnet.dns_servers
}

resource azurerm_subnet aks1 {
	name = "Aks1Subnet"
	resource_group_name  = azurerm_resource_group.spoke1.name
	virtual_network_name = azurerm_virtual_network.spoke1.name
	address_prefixes     = [cidrsubnet(var.address_space, 6, 0)]
	enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "aks-ilb" {
	name = "AksIlbSubnet"
	resource_group_name  = azurerm_resource_group.spoke1.name
	virtual_network_name = azurerm_virtual_network.spoke1.name
	address_prefixes     = [cidrsubnet(var.address_space, 8, 4)]
}

resource "azurerm_subnet" "appgw-aks1" {
	name = "AppGwAks1Subnet"
	resource_group_name  = azurerm_resource_group.spoke1.name
	virtual_network_name = azurerm_virtual_network.spoke1.name
	address_prefixes     = [cidrsubnet(var.address_space, 8, 5)]
}