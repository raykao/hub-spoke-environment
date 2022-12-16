resource "azurerm_private_dns_zone" "global" {
	name                = "internal.${var.domain}"
	resource_group_name = azurerm_resource_group.global.name
}

resource "azurerm_private_dns_zone" "mysql" {
	name                = "privatelink.mysql.database.azure.com"
	resource_group_name = azurerm_resource_group.global.name
}

resource "azurerm_private_dns_zone" "pgsql" {
	name                = "privatelink.postgres.database.azure.com"
	resource_group_name = azurerm_resource_group.global.name
}

resource "azurerm_private_dns_zone" "keyvault" {
	name                = "privatelink.vaultcore.azure.net"
	resource_group_name = azurerm_resource_group.global.name
}
