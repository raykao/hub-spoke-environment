resource "azurerm_resource_group" "spoke1" {
	provider = azurerm.sub1
  	name = "${local.prefix}spoke1-rg"
  	location = var.location1
}