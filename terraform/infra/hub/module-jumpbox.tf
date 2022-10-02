module "jumpbox" {	
	source = "../../modules/jumpbox"
	prefix = local.name
	resource_group = azurerm_resource_group.hub
	subnet_id = azurerm_subnet.jumpbox.id
	admin_username = var.admin_username
	admin_email = var.admin_email
	public_key = var.public_key
	vm_size = "Standard_F16s_v2"
}