resource "azurerm_resource_group" "hub" {
  	name = "${local.prefix}hub"
  	location = var.location
}