resource "azurerm_resource_group" "spoke3" {
	provider = azurerm.sub2
  	name = "${local.prefix}spoke3-rg"
  	location = var.location1
}

resource "azurerm_virtual_network" "spoke3" {
	provider = azurerm.sub2
	name = "${local.prefix}spoke3-vnet"
	resource_group_name = azurerm_resource_group.spoke3.name
	location = azurerm_resource_group.spoke3.location
	address_space       = [var.spoke3_address_space]
}

resource "azurerm_subnet" "spoke3-pe" {
	provider = azurerm.sub2
	name = "StoragePeSubnet"
	resource_group_name  = azurerm_resource_group.spoke3.name
	virtual_network_name = azurerm_virtual_network.spoke3.name
	address_prefixes     = [cidrsubnet(azurerm_virtual_network.spoke3.address_space[0], 8, 0)]
	enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_virtual_network_peering" "spoke3tohub" {
	provider = azurerm.sub2
	name                      = "spoke3tohub"
	resource_group_name       = azurerm_resource_group.spoke3.name
	virtual_network_name      = azurerm_virtual_network.spoke3.name
	remote_virtual_network_id = azurerm_virtual_network.hub.id
}