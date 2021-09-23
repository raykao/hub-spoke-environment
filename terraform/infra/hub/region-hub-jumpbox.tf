module "hub-jumpbox" {
	source = "../modules/jumpbox"
	userMSI = var.contributor_msi.id
  prefix = local.prefix
	resource_group = azurerm_resource_group.hub
	subnet_id = azurerm_subnet.jumpbox.id
	admin_username = var.admin_username
}