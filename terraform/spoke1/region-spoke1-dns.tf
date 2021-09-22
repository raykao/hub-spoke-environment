resource "azurerm_dns_zone" "spoke1" {
	provider = azurerm.sub1
	name                = "spoke1.${var.domain}"
	resource_group_name = azurerm_resource_group.spoke1.name
}