resource "azurerm_private_dns_zone" "hub" {
	name                = "${local.region}.internal.${var.domain}"
	resource_group_name = azurerm_resource_group.hub.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub" {
	name                  = "${local.prefix}-hub1-priv-dns-link"
	resource_group_name   = azurerm_resource_group.hub.name
	private_dns_zone_name = azurerm_private_dns_zone.hub.name
	virtual_network_id    = azurerm_virtual_network.hub.id
}

resource "azurerm_private_dns_zone" "aks" {
	name                = "privatelink.${var.location}.azmk8s.io"
	resource_group_name = azurerm_resource_group.hub.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks" {
	name                  = "${local.prefix}-aks-priv-dns-link"
	resource_group_name   = azurerm_resource_group.hub.name
	private_dns_zone_name = azurerm_private_dns_zone.aks.name
	virtual_network_id    = azurerm_virtual_network.hub.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "global_private_zone" {
	name                  = "${local.prefix}-global-priv-zone-link"
	resource_group_name   = var.global_private_zone.resource_group_name
	private_dns_zone_name = var.global_private_zone.name
	virtual_network_id    = azurerm_virtual_network.hub.id
	registration_enabled = true

}

resource "azurerm_private_dns_zone_virtual_network_link" "global" {
    for_each = var.global_private_dns_zones
    
    name = "${local.prefix}-${each.key}-dns-link"
    resource_group_name = each.value.resource_group_name
    private_dns_zone_name = each.value.name
    virtual_network_id = azurerm_virtual_network.hub.id
}