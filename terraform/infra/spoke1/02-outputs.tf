output vnet {
	value = azurerm_virtual_network.spoke1
}

output resource_group {
	value = azurerm_resource_group.spoke1
}

output public_dns_zone {
	value = azurerm_dns_zone.spoke1
}