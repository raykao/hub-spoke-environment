module spoke1 {
	source = "./spoke1"
	
	providers = {
		azurerm = azurerm.sub1
	}
	prefix = "${local.prefix}s1"
	location = "canadacentral"
	contributor_msi = module.global.contributor_msi
	admin_username = local.admin_username
	address_space = cidrsubnet(var.global_address_space, 8, 1)
	domain = var.domain
	hub = {
		vnet = module.hub.vnet
	}
	admin_groups = var.admin_groups
	admin_email = var.admin_email
	ssh_key = module.global.public_key
}

resource "azurerm_virtual_network_peering" "hubtospoke1" {	
	provider = azurerm.sub1
	name                      = "hubtospoke1"
	resource_group_name       = module.hub.resource_group.name
	virtual_network_name      = module.hub.vnet.name
	remote_virtual_network_id = module.spoke1.vnet.id
}

resource "azurerm_virtual_network_peering" "spoke1tohub" {	
	provider = azurerm.sub1
	name                      = "spoke1tohub"
	resource_group_name       = module.spoke1.resource_group.name
	virtual_network_name      = module.spoke1.vnet.name
	remote_virtual_network_id = module.hub.vnet.id
}

resource "azurerm_dns_ns_record" "spoke1" {
  provider = azurerm.sub1
  name = "spoke1"
  zone_name           = module.global.public_dns_zone.name
  resource_group_name = module.global.public_dns_zone.resource_group_name
  ttl                 = 30

  records = module.spoke1.public_dns_zone.name_servers
}
