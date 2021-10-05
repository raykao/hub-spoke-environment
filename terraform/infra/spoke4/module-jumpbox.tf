module "jumpbox" {
	resource_group = azurerm_resource_group.spoke
	
	source = "../../modules/jumpbox"
	prefix = local.prefix
	subnet_id = azurerm_subnet.jumpbox.id
	admin_username = var.admin_username
	ssh_key = var.ssh_key
	admin_email = var.admin_email
	index = "1"
}