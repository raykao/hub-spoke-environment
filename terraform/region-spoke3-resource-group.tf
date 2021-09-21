resource "azurerm_resource_group" "spoke3" {
	provider = azurerm.sub2
  	name = "${local.prefix}spoke3-rg"
  	location = var.location3
}
