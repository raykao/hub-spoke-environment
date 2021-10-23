module "root-pki" {
  depends_on = [
    module.dns
  ]
	source = "../../modules/pki"
	prefix = local.prefix
	resource_group = azurerm_resource_group.hub
	subnet_id = azurerm_subnet.vault.id
	admin_username = var.admin_username
	ssh_key = var.ssh_key
	admin_subnet = azurerm_subnet.pki
	vm_instances = 2
	domain = azurerm_private_dns_zone.hub.name
	pgsql_private_dns_zone_id = azurerm_private_dns_zone.pgsql.id
	keyvault_private_dns_zone_id = azurerm_private_dns_zone.keyvault.id
}