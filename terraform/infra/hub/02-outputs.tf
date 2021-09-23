output vnet {
	value = azurerm_virtual_network.hub
}

output resource_group {
	value = azurerm_resource_group.hub
}

output jumpbox {
	value = {
		ip_address 	= module.hub-jumpbox.ip
		fqdn				= module.hub-jumpbox.fqdn
		ssh					= "ssh -p 2022 ${var.admin_username}@${module.hub-jumpbox.ip}"
	}
}