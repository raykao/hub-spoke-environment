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

	global_private_zone = var.global_private_zone

	hub_private_dns_zones = module.hub.hub_private_dns_zones
}