module global {
	source = "./global"
	
	providers = {
		azurerm = azurerm.sub1
		pkcs12 = pkcs12
	}
	prefix = local.prefix
	virtual_hub_regions = var.regions
	domain = var.domain
	admin_email = var.admin_email
	onprem_cidr = local.onprem_cidr
}