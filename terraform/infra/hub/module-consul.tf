module "consul" {
	source = "../../modules/consul"
	user_msi = var.contributor_msi.id
	prefix = local.prefix
	resource_group = azurerm_resource_group.hub
	subnet_id = azurerm_subnet.consul.id
	admin_username = var.admin_username
	ssh_key = var.ssh_key
	vm_size = "Standard_F4s_v2"
	admin_subnet = azurerm_subnet.jumpbox
	vm_instances = 3
}