module hub {
	source = "./hub"

	providers = {
		azurerm = azurerm.sub1
	}
	
	prefix = "${local.prefix}"
	location = local.hub_location
	address_space = local.hub_cidr
	jumpbox_cidr = local.jumpbox_cidr
	domain = local.domain
	
	admin_username = local.admin_username
	admin_email = local.admin_email
	public_key = local.public_key

	vwan_hub_id = module.global.virtual_hubs[local.hub_location].id

	firewall_policy_id = module.global.firewall_policy_ids[local.hub_location]
	admin_groups = var.admin_groups
}