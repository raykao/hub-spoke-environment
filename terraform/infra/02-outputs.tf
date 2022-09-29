output subId1 {
	value = var.subId1
}

output subId2 {
	value = var.subId2
}

output hub {
	value = {
		# jumpbox = module.hub.jumpbox
		vnet = {
			id = module.hub.vnet.id
			dns_servers = module.hub.vnet.dns_servers
			address_space = module.hub.vnet.address_space[0]
		}
	}
}

output vpn_s2s_pre_shared_key {
	value = module.global.vpn_psk
}

output vpn_ip {
	value = module.global.vpn_ip
}