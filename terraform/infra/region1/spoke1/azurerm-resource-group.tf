resource "azurerm_resource_group" "spoke" {
  	name = "${local.prefix}"
  	location = var.location
}