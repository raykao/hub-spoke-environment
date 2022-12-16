output vnet {
	value = azurerm_virtual_network.hub
}

output resource_group {
	value = azurerm_resource_group.hub
}

output jumpbox_subnet {
	value = azurerm_subnet.jumpbox
}

output "hub_private_dns_zones" {
	value = {
		keyvault 	= azurerm_private_dns_zone.keyvault
		mysql 		= azurerm_private_dns_zone.mysql
		pgsql		= azurerm_private_dns_zone.pgsql
		aks			= azurerm_private_dns_zone.aks
	}
}

output "win11_password" {
  value = module.win11jumpbox.admin_password
  sensitive = true
}

output "dns_resolvers" {
	value = [
		azurerm_private_dns_resolver_inbound_endpoint.hub.ip_configurations[0].private_ip_address
	]
}