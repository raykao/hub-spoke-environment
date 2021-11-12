output vnet {
	value = azurerm_virtual_network.hub
}

output resource_group {
	value = azurerm_resource_group.hub
}

output admin_subnet {
	value = azurerm_subnet.jumpbox
}


output "keyvault_private_dns_zone_id" {
	value = azurerm_private_dns_zone.keyvault.id
}

output "pgsql_private_dns_zone_id" {
	value = azurerm_private_dns_zone.pgsql.id
}