output vnet {
	value = azurerm_virtual_network.spoke3
}

output resource_group {
	value = azurerm_resource_group.spoke3
}

output public_dns_zone {
	value = azurerm_dns_zone.spoke3
}