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