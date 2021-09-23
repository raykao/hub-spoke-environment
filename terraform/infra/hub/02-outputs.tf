output vnet_id {
	value = azurerm_virtual_network.hub.id
}

output jumpbox {
	value = {
		ip_address 	= module.hub-jumpbox.ip
		fqdn				= module.hub-jumpbox.fqdn
		ssh					= "ssh -p 2022 ${var.admin_username}@${module.hub-jumpbox.ip}"
	}
}