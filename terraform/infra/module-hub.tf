module hub {
	source = "./hub"

	providers = {
		azurerm = azurerm.sub1
	}
	
	prefix = "${local.prefix}hub"
	location = "centralus"
	contributor_msi = module.global.contributor_msi
	admin_username = local.admin_username
	ssh_key = module.global.public_key
	address_space = local.cidrs.hub
	global_address_space = var.global_address_space
	domain = var.domain
	admin_email = var.admin_email
}

resource "azurerm_virtual_hub_connection" "hub" {
	provider 				  = azurerm.sub1
  	name                      = "canadacentral-hub-vhub"
  	virtual_hub_id            = module.global.virtual_hubs["canadacentral"].id
  	remote_virtual_network_id = module.hub.vnet.id
	internet_security_enabled = true
}