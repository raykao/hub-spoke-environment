# resource "azurerm_dns_zone" "spoke1" {
# 	name                = "${local.region}.${var.domain}"
# 	resource_group_name = azurerm_resource_group.spoke1.name
# }

resource "azurerm_dns_zone" "spoke1" {
	name                = "${local.region}.${var.domain}"
	resource_group_name = azurerm_resource_group.spoke1.name
}

resource "azurerm_private_dns_zone" "spoke1" {
	name                = "${local.region}.internal.${var.domain}"
	resource_group_name = azurerm_resource_group.spoke1.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "spoke1" {
	name                  = "spoke1-priv-dns-link"
	resource_group_name   = azurerm_resource_group.spoke1.name
	private_dns_zone_name = azurerm_private_dns_zone.spoke1.name
	virtual_network_id    = azurerm_virtual_network.spoke1.id
	registration_enabled  = true
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub" {
	name                  = "hub-priv-dns-link"
	resource_group_name   = azurerm_resource_group.spoke1.name
	private_dns_zone_name = azurerm_private_dns_zone.spoke1.name
	virtual_network_id    = var.hub.vnet.id
}

resource "azurerm_private_dns_zone" "aks" {
	name                = "privatelink.${azurerm_resource_group.spoke1.location}.azmk8s.io"
	resource_group_name = azurerm_resource_group.spoke1.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "spoke1-aks" {
	name                  = "spoke1-priv-aks-dns-link"
	resource_group_name   = azurerm_resource_group.spoke1.name
	private_dns_zone_name = azurerm_private_dns_zone.aks.name
	virtual_network_id    = azurerm_virtual_network.spoke1.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub-aks" {
	name                  = "hub-priv-aks-dns-link"
	resource_group_name   = azurerm_resource_group.spoke1.name
	private_dns_zone_name = azurerm_private_dns_zone.aks.name
	virtual_network_id    = var.hub.vnet.id
}
