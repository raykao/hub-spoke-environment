resource "azurerm_resource_group" "hub" {
	provider = azurerm.sub1
  	name = "${local.prefix}hub-rg"
  	location = var.location1
}