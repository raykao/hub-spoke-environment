resource "azurerm_storage_account" "vault" {
  name = "${local.prefix}vaultstore"
  location = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Allow"
    virtual_network_subnet_ids = [azurerm_subnet.vault.id]
  }
}

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
  storage_account = azurerm_storage_account.vault
  pgsql_private_dns_zone_id = azurerm_private_dns_zone.pgsql.id
  keyvault_private_dns_zone_id = azurerm_private_dns_zone.keyvault.id
}

resource "azurerm_private_dns_a_record" "vault" {
  name                = "vault"
  zone_name           = azurerm_private_dns_zone.hub.name
  resource_group_name = azurerm_resource_group.hub.name
  ttl                 = 300
  records             = [module.vault.lb.frontend_ip_configuration[0].private_ip_address]
}