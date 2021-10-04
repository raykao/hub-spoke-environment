resource "azurerm_dns_zone" "global" {
	name                = "${var.domain}"
	resource_group_name = azurerm_resource_group.global.name
}

resource "azurerm_private_dns_zone" "global" {
	name                = "${var.domain}"
	resource_group_name = azurerm_resource_group.global.name
}