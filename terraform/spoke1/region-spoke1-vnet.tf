resource "azurerm_virtual_network" "spoke1" {
	provider = azurerm.sub1
	name = "${local.prefix}spoke1-vnet"
	resource_group_name = azurerm_resource_group.spoke1.name
	location = azurerm_resource_group.spoke1.location
	address_space       = [var.spoke1_address_space]
}

resource azurerm_subnet aks {
	provider = azurerm.sub1
	name = "AksSubnet"
	resource_group_name  = azurerm_resource_group.spoke1.name
	virtual_network_name = azurerm_virtual_network.spoke1.name
	address_prefixes     = [cidrsubnet(azurerm_virtual_network.spoke1.address_space[0], 6, 0)]
}

resource "azurerm_virtual_network_peering" "spoke1tohub" {
	provider = azurerm.sub1
	name                      = "spoke1tohub"
	resource_group_name       = azurerm_resource_group.spoke1.name
	virtual_network_name      = azurerm_virtual_network.spoke1.name
	remote_virtual_network_id = azurerm_virtual_network.hub.id
}
