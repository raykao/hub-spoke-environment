module spoke3 {
	source = "./spoke3"
	
	providers = {
		azurerm = azurerm.sub2
	}
	prefix = "${local.prefix}s3"
	location = "eastus"
	contributor_msi = module.global.contributor_msi
	admin_username = local.admin_username
	ssh_key = module.global.public_key
	address_space = cidrsubnet(var.global_address_space, 8, 3)
	domain = var.domain
	hub = {
		vnet = module.hub.vnet
	}
	admin_email = var.admin_email
}

resource "azurerm_virtual_network_peering" "hubtospoke3" {
	provider = azurerm.sub1
	name                      = "hubtospoke3"
	resource_group_name       = module.hub.resource_group.name
	virtual_network_name      = module.hub.vnet.name
	remote_virtual_network_id = module.spoke3.vnet.id
}

resource "azurerm_virtual_network_peering" "spoke3tohub" {	
	provider = azurerm.sub2
	name                      = "spoke3tohub"
	resource_group_name       = module.spoke3.resource_group.name
	virtual_network_name      = module.spoke3.vnet.name
	remote_virtual_network_id = module.hub.vnet.id
}
