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

module "hub-jumpbox" {
	source = "./modules/jumpbox"
	providers = {
		azurerm = azurerm.sub1
	}
	userMSI = azurerm_user_assigned_identity.jumpbox.id
  prefix = local.prefix
	resource_group = azurerm_resource_group.hub
	subnet_id = azurerm_subnet.jumpbox.id
	admin_username = local.admin_username
}