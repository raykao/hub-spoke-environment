# resource "azurerm_dns_zone" "spoke1" {
# 	name                = "spoke1.${var.domain}"
# 	resource_group_name = azurerm_resource_group.spoke1.name
# }

resource "azurerm_private_dns_zone" "spoke1" {
	name                = "spoke1.${var.domain}"
	resource_group_name = azurerm_resource_group.spoke1.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "spoke1" {
	name                  = "spoke1-priv-dns-link"
	resource_group_name   = azurerm_resource_group.spoke1.name
	private_dns_zone_name = azurerm_private_dns_zone.spoke1.name
	virtual_network_id    = azurerm_virtual_network.spoke1.id
	registration_enabled  = true
}
