resource "azurerm_key_vault" "hub" {
	provider = azurerm.sub1
	name                = "${local.prefix}hubkeyvault"
	location            = azurerm_resource_group.hub.location
	resource_group_name = azurerm_resource_group.hub.name
	tenant_id           = azurerm_user_assigned_identity.jumpbox.tenant_id
	sku_name            = "premium"
}

resource "azurerm_key_vault_access_policy" "hub" {
	provider = azurerm.sub1
	key_vault_id = azurerm_key_vault.hub.id
	tenant_id    = azurerm_user_assigned_identity.jumpbox.tenant_id
	object_id    = azurerm_user_assigned_identity.jumpbox.principal_id
  
	certificate_permissions = [
		"Backup",
		"Create",
		"Delete",
		"DeleteIssuers",
		"Get",
		"GetIssuers",
		"Import",
		"List",
		"ListIssuers",
		"ManageContacts",
		"ManageIssuers",
		"Purge",
		"Recover",
		"Restore",
		"SetIssuers",
		"Update"
	]

	key_permissions = [
		"Backup",
		"Create",
		"Decrypt",
		"Delete",
		"Encrypt",
		"Get",
		"Import",
		"List",
		"Purge",
		"Recover",
		"Restore",
		"Sign",
		"UnwrapKey",
		"Update",
		"Verify",
		"WrapKey"
	]

	secret_permissions = [
		"Backup",
		"Delete",
		"Get",
		"List",
		"Purge",
		"Recover",
		"Restore",
		"Set"
	]
}