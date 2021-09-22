resource "azurerm_user_assigned_identity" "contributor" {
	resource_group_name = azurerm_resource_group.global.name
	location            = azurerm_resource_group.global.location

	name = "${local.prefix}-contributor-user-msi"
}

resource "azurerm_role_assignment" "global" {
	scope                = azurerm_resource_group.global.id
	role_definition_name = "Contributor"
	principal_id         = azurerm_user_assigned_identity.contributor.principal_id
}