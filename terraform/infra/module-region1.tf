module region1 {
	source = "./region1"

	providers = {
		azurerm = azurerm.sub1
	}
	
	prefix = "${local.prefix}"
	region = "r1"
	
	location = local.regions[0]
	
	region_cidr_range = local.region1_cidr

	domain = local.domain
	
	admin_username = local.admin_username
	admin_email = local.admin_email
	public_key = local.public_key

	vwan_hub_id = module.global.virtual_hubs[local.regions[0]].id

	firewall_ip = module.global.firewall_ips[local.regions[0]][0]
	firewall_policy_id = module.global.firewall_policy_ids[local.regions[0]]
	
	admin_groups = var.admin_groups
	
	onprem_domain = var.onprem_domain
	onprem_dns_server = var.onprem_dns_server

	global_private_zone = module.global.global_private_zone
	global_private_dns_zones = module.global.private_dns_zones
}