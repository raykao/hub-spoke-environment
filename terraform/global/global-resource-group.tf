resource "azurerm_resource_group" "global" {
	provider = azurerm.sub1
  	name = "${local.prefix}global-rg"
  	location = var.location1
}