module hub {
	source = "./hub"

	providers = {
		azurerm = azurerm.sub1
	}
	
	prefix = "${local.prefix}"
	location = local.hub_location
	
	admin_username = local.admin_username
	admin_email = local.admin_email
	public_key = local.public_key

	domain = local.domain
	address_space = local.hub_cidr
	global_address_space = local.global_address_space

	firewall_policy_id = module.global.firewall_policy_ids[local.hub_location]
}

resource "azurerm_virtual_hub_connection" "hub" {
	provider 				  = azurerm.sub1
  	name                      = "${local.hub_location}-hub-vhub"
  	virtual_hub_id            = module.global.virtual_hubs[local.hub_location].id
  	remote_virtual_network_id = module.hub.vnet.id
	internet_security_enabled = true
}