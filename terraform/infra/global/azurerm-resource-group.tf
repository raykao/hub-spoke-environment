resource "azurerm_resource_group" "global" {
  	name = "${local.prefix}global"
  	location = var.location
}