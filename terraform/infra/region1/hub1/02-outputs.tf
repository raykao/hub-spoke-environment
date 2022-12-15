output vnet {
	value = azurerm_virtual_network.hub
}

output resource_group {
	value = azurerm_resource_group.hub
}

output jumpbox_subnet {
	value = azurerm_subnet.jumpbox
}

output "keyvault_private_dns_zone_id" {
	value = azurerm_private_dns_zone.keyvault.id
}

output "mysql_private_dns_zone_id" {
	value = azurerm_private_dns_zone.mysql.id
}

output "pgsql_private_dns_zone_id" {
	value = azurerm_private_dns_zone.pgsql.id
}

output "win11_password" {
  value = module.win11jumpbox.admin_password
  sensitive = true
}

output "dns_resolver" {
	value = azurerm_private_dns_resolver_inbound_endpoint.hub.ip_configurations[0].private_ip_address
}