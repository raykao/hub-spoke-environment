output vnet {
	value = azurerm_virtual_network.hub
}

output resource_group {
	value = azurerm_resource_group.hub
}

output jumpbox {
	value = {
		ip_address 	= module.jumpbox.ip
		fqdn				= module.jumpbox.fqdn
		# ssh					= "ssh -p 2022 ${var.admin_username}@${module.jumpbox.ip}"
		ssh 				= "ssh -p 2022 -i ./certs/${terraform.workspace}/global/id_rsa ${var.admin_username}@${module.jumpbox.fqdn}"
		
	}
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