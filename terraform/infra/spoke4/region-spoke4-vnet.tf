resource "azurerm_virtual_network" "spoke4" {
	
	name = "${local.prefix}spoke4-vnet"
	resource_group_name = azurerm_resource_group.spoke4.name
	location = azurerm_resource_group.spoke4.location
	address_space       = [var.spoke4_address_space]
}

resource "azurerm_subnet" "spoke4-pe" {
	
	name = "Default"
	resource_group_name  = azurerm_resource_group.spoke4.name
	virtual_network_name = azurerm_virtual_network.spoke4.name
	address_prefixes     = [cidrsubnet(azurerm_virtual_network.spoke4.address_space[0], 8, 0)]
}

resource "azurerm_subnet" "spoke4-vpn" {
	
	name = "GatewaySubnet"
	resource_group_name  = azurerm_resource_group.spoke4.name
	virtual_network_name = azurerm_virtual_network.spoke4.name
	address_prefixes     = [cidrsubnet(azurerm_virtual_network.spoke4.address_space[0], 8, 1)]
}

resource "azurerm_subnet" "spoke4-jumpbox" {
	
	name = "JumpboxSubnet"
	resource_group_name  = azurerm_resource_group.spoke4.name
	virtual_network_name = azurerm_virtual_network.spoke4.name
	address_prefixes     = [cidrsubnet(azurerm_virtual_network.spoke4.address_space[0], 8, 255)]
}