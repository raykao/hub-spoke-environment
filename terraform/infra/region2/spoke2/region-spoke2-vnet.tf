resource "azurerm_virtual_network" "spoke2" {
	name = "${local.prefix}spoke2-vnet"
	resource_group_name = azurerm_resource_group.spoke2.name
	location = azurerm_resource_group.spoke2.location
	address_space       = [var.address_space]
	dns_servers = var.hub.vnet.dns_servers
}

resource "azurerm_subnet" "spoke2-pe" {
	name = "StoragePeSubnet"
	resource_group_name  = azurerm_resource_group.spoke2.name
	virtual_network_name = azurerm_virtual_network.spoke2.name
	address_prefixes     = [cidrsubnet(azurerm_virtual_network.spoke2.address_space[0], 8, 0)]
	enforce_private_link_endpoint_network_policies = true
}
