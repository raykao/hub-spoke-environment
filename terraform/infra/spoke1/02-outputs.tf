output vnet {
	value = azurerm_virtual_network.spoke1
}

output resource_group {
	value = azurerm_resource_group.spoke1
}

output dnszone {
	value = azurerm_private_dns_zone_virtual_network_link.spoke1.id
}