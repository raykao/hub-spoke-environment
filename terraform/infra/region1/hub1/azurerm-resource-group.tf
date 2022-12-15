resource "azurerm_resource_group" "hub" {
  	name = "${local.name}"
  	location = var.location
}