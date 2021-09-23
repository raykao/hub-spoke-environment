resource "azurerm_virtual_network" "spoke3" {
	name = "${local.prefix}spoke3-vnet"
	resource_group_name = azurerm_resource_group.spoke3.name
	location = azurerm_resource_group.spoke3.location
	address_space       = [var.address_space]
}

resource "azurerm_subnet" "spoke3-pe" {
	name = "Default"
	resource_group_name  = azurerm_resource_group.spoke3.name
	virtual_network_name = azurerm_virtual_network.spoke3.name
	address_prefixes     = [cidrsubnet(azurerm_virtual_network.spoke3.address_space[0], 8, 0)]
}

resource "azurerm_subnet" "jumpbox" {
	name = "JumpboxSubnet"
	resource_group_name  = azurerm_resource_group.spoke3.name
	virtual_network_name = azurerm_virtual_network.spoke3.name
	address_prefixes     = [cidrsubnet(azurerm_virtual_network.spoke3.address_space[0], 8, 255)]
}