module hub {
	source = "./hub"
	
	prefix = "${local.prefix}"
	location = var.location
	address_space = local.hub_cidr
	
	domain = var.domain
	
	admin_username = var.admin_username
	admin_email = var.admin_email
	public_key = var.public_key

	vwan_hub_id = var.vwan_hub_id

	firewall_ip = var.vwan_hub_id
	firewall_policy_id = var.firewall_policy_id
	admin_groups = var.admin_groups

	onprem_dns_server = var.onprem_dns_server
	onprem_domain = var.onprem_domain
}