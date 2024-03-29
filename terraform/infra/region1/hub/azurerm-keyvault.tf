# resource "azurerm_key_vault" "hub" {
# 	name                = "${local.name}keyvault"
# 	location            = azurerm_resource_group.hub.location
# 	resource_group_name = azurerm_resource_group.hub.name
# 	tenant_id           = data.azurerm_client_config.current.tenant_id
# 	sku_name            = "premium"
# }

# resource "azurerm_key_vault_access_policy" "user-hub" {
	
# 	key_vault_id = azurerm_key_vault.hub.id
# 	tenant_id    = data.azurerm_client_config.current.tenant_id
# 	object_id    = data.azurerm_client_config.current.object_id
  
# 	certificate_permissions = [
# 		"Backup",
# 		"Create",
# 		"Delete",
# 		"DeleteIssuers",
# 		"Get",
# 		"GetIssuers",
# 		"Import",
# 		"List",
# 		"ListIssuers",
# 		"ManageContacts",
# 		"ManageIssuers",
# 		"Purge",
# 		"Recover",
# 		"Restore",
# 		"SetIssuers",
# 		"Update"
# 	]

# 	key_permissions = [
# 		"Backup",
# 		"Create",
# 		"Decrypt",
# 		"Delete",
# 		"Encrypt",
# 		"Get",
# 		"Import",
# 		"List",
# 		"Purge",
# 		"Recover",
# 		"Restore",
# 		"Sign",
# 		"UnwrapKey",
# 		"Update",
# 		"Verify",
# 		"WrapKey"
# 	]

# 	secret_permissions = [
# 		"Backup",
# 		"Delete",
# 		"Get",
# 		"List",
# 		"Purge",
# 		"Recover",
# 		"Restore",
# 		"Set"
# 	]
# }

# # resource "azurerm_key_vault_access_policy" "user-msi-hub" {
# # 	key_vault_id = azurerm_key_vault.hub.id
# # 	tenant_id    = data.azurerm_client_config.current.tenant_id
# # 	object_id    = var.contributor_msi.principal_id
  
# # 	certificate_permissions = [
# # 		"Backup",
# # 		"Create",
# # 		"Delete",
# # 		"DeleteIssuers",
# # 		"Get",
# # 		"GetIssuers",
# # 		"Import",
# # 		"List",
# # 		"ListIssuers",
# # 		"ManageContacts",
# # 		"ManageIssuers",
# # 		"Purge",
# # 		"Recover",
# # 		"Restore",
# # 		"SetIssuers",
# # 		"Update"
# # 	]

# # 	key_permissions = [
# # 		"Backup",
# # 		"Create",
# # 		"Decrypt",
# # 		"Delete",
# # 		"Encrypt",
# # 		"Get",
# # 		"Import",
# # 		"List",
# # 		"Purge",
# # 		"Recover",
# # 		"Restore",
# # 		"Sign",
# # 		"UnwrapKey",
# # 		"Update",
# # 		"Verify",
# # 		"WrapKey"
# # 	]

# # 	secret_permissions = [
# # 		"Backup",
# # 		"Delete",
# # 		"Get",
# # 		"List",
# # 		"Purge",
# # 		"Recover",
# # 		"Restore",
# # 		"Set"
# # 	]
# # }