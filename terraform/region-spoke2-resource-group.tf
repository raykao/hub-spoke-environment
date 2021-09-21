resource "azurerm_resource_group" "spoke2" {
	provider = azurerm.sub2
  	name = "${local.prefix}spoke2-rg"
  	location = var.location2
}