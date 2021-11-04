module spoke4 {
	source = "./spoke4"
	
	providers = {
		azurerm = azurerm.sub2
	}
	prefix = "${local.prefix}"
	address_space = cidrsubnet(var.global_address_space, 8, 4)
	location = "japaneast"

	contributor_msi = module.global.contributor_msi
	admin_username = local.admin_username
	ssh_key = module.global.public_key
	domain = var.domain
	hub = {
		vnet = module.hub.vnet
	}
	admin_email = var.admin_email
	admin_groups = var.admin_groups
}

resource "azurerm_virtual_hub_connection" "spoke4" {
	provider = azurerm.sub1
  name                      = "southeastasia-spoke4-vhub"
  virtual_hub_id            = module.global.virtual_hubs["southeastasia"].id
  remote_virtual_network_id = module.spoke4.vnet.id
}

resource "azurerm_dns_ns_record" "spoke4" {
  provider = azurerm.sub1
  name = "spoke4"
  zone_name           = module.global.public_dns_zone.name
  resource_group_name = module.global.public_dns_zone.resource_group_name
  ttl                 = 30

  records = module.spoke4.public_dns_zone.name_servers
}
