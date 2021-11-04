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

resource "azurerm_virtual_hub_connection" "spoke1" {
	provider = azurerm.sub1
  name                      = "canadacentral-spoke1-vhub"
  virtual_hub_id            = module.global.virtual_hubs["canadacentral"].id
  remote_virtual_network_id = module.spoke1.vnet.id
	internet_security_enabled = true
}

resource "azurerm_dns_ns_record" "spoke1" {
  provider = azurerm.sub1
  name = "spoke1"
  zone_name           = module.global.public_dns_zone.name
  resource_group_name = module.global.public_dns_zone.resource_group_name
  ttl                 = 30

  records = module.spoke1.public_dns_zone.name_servers
}
