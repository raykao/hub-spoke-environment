module "jumpbox" {	
	source = "../../modules/jumpbox"
	prefix = local.prefix
	resource_group = azurerm_resource_group.spoke1
	subnet_id = azurerm_subnet.jumpbox.id
	admin_username = var.admin_username
	ssh_key = var.ssh_key
	vm_size = "Standard_F16s_v2"
	admin_email = var.admin_email
	index = "1"
}