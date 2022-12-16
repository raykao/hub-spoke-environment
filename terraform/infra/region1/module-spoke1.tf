module spoke1 {
	source = "./spoke1"

	prefix = "${local.prefix}"
	location = var.location
	address_space = local.spoke1_cidr
	
	domain = var.domain
	
	admin_username = var.admin_username
	admin_email = var.admin_email
	public_key = var.public_key

	vwan_hub_id = var.vwan_hub_id

	firewall_ip = var.vwan_hub_id
	firewall_policy_id = var.firewall_policy_id

	admin_groups = var.admin_groups
	
	dns_servers = module.hub.dns_resolvers

	hub_private_dns_zones = module.hub.hub_private_dns_zones
}

# resource "azurerm_virtual_hub_connection" "spoke1" {
# 	provider = azurerm.sub1
#   name                      = "canadacentral-spoke1-vhub"
#   virtual_hub_id            = module.global.virtual_hubs["canadacentral"].id
#   remote_virtual_network_id = module.spoke1.vnet.id
# 	internet_security_enabled = true
# }

# resource "azurerm_dns_ns_record" "spoke1" {
#   provider = azurerm.sub1
#   name = "spoke1"
#   zone_name           = module.global.public_dns_zone.name
#   resource_group_name = module.global.public_dns_zone.resource_group_name
#   ttl                 = 30

#   records = module.spoke1.public_dns_zone.name_servers
# }