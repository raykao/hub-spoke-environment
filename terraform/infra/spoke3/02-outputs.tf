output vnet {
	value = azurerm_virtual_network.spoke3
}

output resource_group {
	value = azurerm_resource_group.spoke3
}

output jumpbox {
	value = {
		ip_address 	= module.jumpbox.ip
		fqdn				= module.jumpbox.fqdn
		ssh					= "ssh -p 2022 ${var.admin_username}@${module.jumpbox.ip}"
	}
}

output public_dns_zone {
	value = azurerm_dns_zone.spoke3
}