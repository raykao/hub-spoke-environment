# module spoke3 {
# 	source = "./spoke3"
	
# 	providers = {
# 		azurerm = azurerm.sub2
# 	}
# 	prefix = "${local.prefix}s3"
# 	location = "eastus"
# 	contributor_msi = module.global.contributor_msi
# 	admin_username = local.admin_username
# 	ssh_key = module.global.public_key
# 	address_space = cidrsubnet(var.global_address_space, 8, 3)
# 	domain = var.domain
# 	hub = {
# 		vnet = module.hub.vnet
# 	}
# 	admin_email = var.admin_email
# 	pgsql_private_dns_zone_id = module.hub.pgsql_private_dns_zone_id
# 	keyvault_private_dns_zone_id = module.hub.keyvault_private_dns_zone_id
# }

# resource "azurerm_virtual_hub_connection" "spoke3" {
# 	provider 									= azurerm.sub1
#   name                      = "canadacentral-spoke3-vhub"
#   virtual_hub_id            = module.global.virtual_hubs["canadacentral"].id
#   remote_virtual_network_id = module.spoke3.vnet.id
# 	internet_security_enabled = true
# }

# resource "azurerm_dns_ns_record" "spoke3" {
#   provider = azurerm.sub1
#   name = "spoke3"
#   zone_name           = module.global.public_dns_zone.name
#   resource_group_name = module.global.public_dns_zone.resource_group_name
#   ttl                 = 30

#   records = module.spoke3.public_dns_zone.name_servers
# }
