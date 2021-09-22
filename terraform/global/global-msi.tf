resource "azurerm_user_assigned_identity" "jumpbox" {
	provider = azurerm.sub1
	resource_group_name = azurerm_resource_group.hub.name
	location            = azurerm_resource_group.hub.location

	name = "${local.prefix}-jumpbox-user-msi"
}

resource "azurerm_role_assignment" "hub" {
	provider = azurerm.sub1
	scope                = azurerm_resource_group.hub.id
	role_definition_name = "Contributor"
	principal_id         = azurerm_user_assigned_identity.jumpbox.principal_id
}