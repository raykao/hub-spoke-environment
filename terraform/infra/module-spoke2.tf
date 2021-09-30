module spoke2 {
	source = "./spoke2"
	
	providers = {
		azurerm = azurerm.sub2
	}
	prefix = "${local.prefix}s2"
	location = "canadacentral"
	contributor_msi = local.global.contributor_msi
	admin_username = local.admin_username
	address_space = cidrsubnet(var.global_address_space, 8, 2)
	domain = var.domain
	priv-dns-zone-links = {
		hub = module.hub.vnet.id
		spoke1 = module.spoke1.vnet.id
	}
	hub = {
		vnet = module.hub.vnet
	}
}

resource "azurerm_virtual_network_peering" "hubtospoke2" {	
	provider = azurerm.sub1
	name                      = "hubtospoke2"
	resource_group_name       = module.hub.resource_group.name
	virtual_network_name      = module.hub.vnet.name
	remote_virtual_network_id = module.spoke2.vnet.id
}

resource "azurerm_virtual_network_peering" "spoke2tohub" {	
	provider = azurerm.sub2
	name                      = "spoke2tohub"
	resource_group_name       = module.spoke2.resource_group.name
	virtual_network_name      = module.spoke2.vnet.name
	remote_virtual_network_id = module.hub.vnet.id
}