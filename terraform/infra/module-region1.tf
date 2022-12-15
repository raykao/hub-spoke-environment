module hub {
	source = "./region1/hub1"

	providers = {
		azurerm = azurerm.sub1
	}
	
	prefix = "${local.prefix}"
	location = local.hub_location
	address_space = local.hub_cidr
	domain = local.domain
	
	admin_username = local.admin_username
	admin_email = local.admin_email
	public_key = local.public_key

	vwan_hub_id = module.global.virtual_hubs[local.hub_location].id

	firewall_ip = module.global.firewall_ips[local.hub_location][0]
	firewall_policy_id = module.global.firewall_policy_ids[local.hub_location]
	admin_groups = var.admin_groups
	onprem_dns_server = var.onprem_dns_server
	onprem_domain = var.onprem_domain
}

module spoke1 {
	source = "./spoke1"
	
	providers = {
		azurerm = azurerm.sub1
	}
    
	prefix = "${local.prefix}s1"
	location = "canadacentral"
	contributor_msi = module.global.contributor_msi
	admin_username = local.admin_username
	address_space = local.spoke1_cidr
	domain = var.domain
	hub = {
		vnet = module.hub.vnet
	}
	admin_groups = var.admin_groups
	admin_email = var.admin_email
	ssh_key = module.global.public_key

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
