module "root-pki" {
  depends_on = [
    module.dns
  ]
	source = "../../modules/pki"
	prefix = local.prefix
	resource_group = azurerm_resource_group.hub
	subnet_id = azurerm_subnet.pki.id
	admin_username = var.admin_username
	ssh_key = var.ssh_key
	admin_subnet = azurerm_subnet.jumpbox
	vm_instances = 2
	domain = azurerm_private_dns_zone.hub.name
	mysql_private_dns_zone_id = azurerm_private_dns_zone.mysql.id
	keyvault_private_dns_zone_id = azurerm_private_dns_zone.keyvault.id
}