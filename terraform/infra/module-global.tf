module global {
	source = "./global"
	
	providers = {
		azurerm = azurerm.sub1
	}
	prefix = local.prefix
	location = "canadacentral"
	domain = var.domain
}