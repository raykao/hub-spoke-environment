resource "azurerm_dns_zone" "spoke3" {
	name                = "${local.region}.${var.domain}"
	resource_group_name = azurerm_resource_group.spoke3.name
}


resource "azurerm_private_dns_zone" "spoke3" {
	name                = "${local.region}.${var.domain}"
	resource_group_name = azurerm_resource_group.spoke3.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "spoke3" {
	name                  = "spoke3-priv-dns-link"
	resource_group_name   = azurerm_resource_group.spoke3.name
	private_dns_zone_name = azurerm_private_dns_zone.spoke3.name
	virtual_network_id    = azurerm_virtual_network.spoke3.id
	registration_enabled  = true
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub" {
	name                  = "hub-priv-dns-link"
	resource_group_name   = azurerm_resource_group.spoke3.name
	private_dns_zone_name = azurerm_private_dns_zone.spoke3.name
	virtual_network_id    = var.hub.vnet.id
}