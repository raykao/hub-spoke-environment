resource "azurerm_private_dns_zone" "hub" {
	name                = "${local.region}.internal.${var.domain}"
	resource_group_name = azurerm_resource_group.hub.name
}

resource "azurerm_private_dns_zone" "pgsql" {
	name                = "privatelink.postgres.database.azure.com"
	resource_group_name = azurerm_resource_group.hub.name
}

resource "azurerm_private_dns_zone" "keyvault" {
	name                = "privatelink.vaultcore.azure.net"
	resource_group_name = azurerm_resource_group.hub.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub" {
	name                  = "hub-priv-dns-link"
	resource_group_name   = azurerm_resource_group.hub.name
	private_dns_zone_name = azurerm_private_dns_zone.hub.name
	virtual_network_id    = azurerm_virtual_network.hub.id
	registration_enabled  = true
}

resource "azurerm_private_dns_zone_virtual_network_link" "pgsql" {
	name                  = "hub-pgsql-priv-dns-link"
	resource_group_name   = azurerm_resource_group.hub.name
	private_dns_zone_name = azurerm_private_dns_zone.pgsql.name
	virtual_network_id    = azurerm_virtual_network.hub.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault" {
	name                  = "hub-keyvault-priv-dns-link"
	resource_group_name   = azurerm_resource_group.hub.name
	private_dns_zone_name = azurerm_private_dns_zone.keyvault.name
	virtual_network_id    = azurerm_virtual_network.hub.id
}