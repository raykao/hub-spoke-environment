resource "azurerm_private_dns_zone" "aks" {
	name                = "privatelink.${azurerm_resource_group.default.location}.azmk8s.io"
	resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "default-aks" {
	name                  = "default-priv-aks-dns-link"
	resource_group_name   = azurerm_resource_group.default.name
	private_dns_zone_name = azurerm_private_dns_zone.aks.name
	virtual_network_id    = azurerm_virtual_network.default.id
}

resource "azurerm_user_assigned_identity" "aks" {
  name                = "${local.name}-aks-identity"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

resource "azurerm_role_assignment" "aks-dns" {
  scope                = azurerm_private_dns_zone.aks.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_role_assignment" "aks-network-contrib" {  	
	scope                = azurerm_virtual_network.default.id
	role_definition_name = "Network Contributor"
	principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_role_assignment" "aks-contributor" {  	
	scope                = azurerm_resource_group.default.id
	role_definition_name = "Contributor"
	principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

module aks1 {
	source = "../modules/aks/private"

	prefix = "${local.name}"
	suffix = "1"
	resource_group = azurerm_resource_group.default
	subnet_id = azurerm_subnet.aks.id
	private_dns_zone_id = azurerm_private_dns_zone.aks.id
	user_msi_id =  azurerm_user_assigned_identity.aks.id
	admin_group_object_ids = var.admin_groups.aks
}