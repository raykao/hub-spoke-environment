resource "azurerm_dns_zone" "spoke2" {
	name                = "${local.region}.${var.domain}"
	resource_group_name = azurerm_resource_group.spoke2.name
}

resource "azurerm_private_dns_zone" "spoke2" {
	name                = "${local.region}.internal.${var.domain}"
	resource_group_name = azurerm_resource_group.spoke2.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "spoke2" {
	name                  = "spoke2-priv-dns-link"
	resource_group_name   = azurerm_resource_group.spoke2.name
	private_dns_zone_name = azurerm_private_dns_zone.spoke2.name
	virtual_network_id    = azurerm_virtual_network.spoke2.id
	registration_enabled  = true
}

resource "azurerm_private_dns_zone" "storage-priv-link" {
	name                = "privatelink.file.core.windows.net"
	resource_group_name = azurerm_resource_group.spoke2.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage-pe" {
	name                  = "priv-link-spoke2"
	resource_group_name   = azurerm_resource_group.spoke2.name
	private_dns_zone_name = azurerm_private_dns_zone.storage-priv-link.name
	virtual_network_id    = azurerm_virtual_network.spoke2.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage" {
	for_each = var.priv-dns-zone-links
	name                  = "priv-link-${each.key}"
	resource_group_name   = azurerm_resource_group.spoke2.name
	private_dns_zone_name = azurerm_private_dns_zone.storage-priv-link.name
	virtual_network_id    = each.value
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub" {
	name                  = "hub-priv-dns-link"
	resource_group_name   = azurerm_resource_group.spoke2.name
	private_dns_zone_name = azurerm_private_dns_zone.spoke2.name
	virtual_network_id    = var.hub.vnet.id
}
