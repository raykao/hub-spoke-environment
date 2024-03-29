# module spoke2 {
# 	source = "./spoke2"
	
# 	providers = {
# 		azurerm = azurerm.sub2
# 	}
# 	prefix = "${local.prefix}s2"
# 	location = "canadacentral"
# 	contributor_msi = module.global.contributor_msi
# 	admin_username = local.admin_username
# 	address_space = local.cidrs.spoke2
# 	domain = var.domain
# 	priv-dns-zone-links = {
# 		hub = module.hub.vnet.id
# 		spoke1 = module.spoke1.vnet.id
# 	}
# 	hub = {
# 		vnet = module.hub.vnet
# 	}
# }

# resource "azurerm_virtual_hub_connection" "spoke2" {
# 	provider = azurerm.sub1
#   name                      = "canadacentral-spoke2-vhub"
#   virtual_hub_id            = module.global.virtual_hubs["canadacentral"].id
#   remote_virtual_network_id = module.spoke2.vnet.id
# 	internet_security_enabled = true
# }

# resource "azurerm_dns_ns_record" "spoke2" {
#   provider = azurerm.sub1
#   name = "spoke2"
#   zone_name           = module.global.public_dns_zone.name
#   resource_group_name = module.global.public_dns_zone.resource_group_name
#   ttl                 = 30

#   records = module.spoke2.public_dns_zone.name_servers
# }
