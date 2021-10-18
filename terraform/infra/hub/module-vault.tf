module "vault" {
	source = "../../modules/vault"
	prefix = local.prefix
	resource_group = azurerm_resource_group.hub
	subnet_id = azurerm_subnet.vault.id
	admin_username = var.admin_username
	ssh_key = var.ssh_key
	vm_size = "Standard_F4s_v2"
	admin_subnet = azurerm_subnet.jumpbox
	vm_instances = 3
  domain = azurerm_private_dns_zone.hub.name
  pgsql_private_dns_zone_id = azurerm_private_dns_zone.pgsql.id
  keyvault_private_dns_zone_id = azurerm_private_dns_zone.keyvault.id
}