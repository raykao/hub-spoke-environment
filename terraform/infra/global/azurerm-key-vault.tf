# resource "azurerm_key_vault" "global" {
	
# 	name                = "${local.prefix}globalkeyvault"
# 	location            = azurerm_resource_group.global.location
# 	resource_group_name = azurerm_resource_group.global.name
# 	tenant_id           = data.azurerm_client_config.current.tenant_id
# 	sku_name            = "premium"
# }

# resource "azurerm_key_vault_access_policy" "user-global" {
	
# 	key_vault_id = azurerm_key_vault.global.id
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

# resource "azurerm_key_vault_access_policy" "user-msi-global" {
	
# 	key_vault_id = azurerm_key_vault.global.id
# 	tenant_id    = data.azurerm_client_config.current.tenant_id
# 	object_id    = azurerm_user_assigned_identity.contributor.principal_id
  
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


# resource "azurerm_key_vault_certificate" "root-ca" {
#   depends_on = [
#     azurerm_key_vault_access_policy.user-global
#   ]

#   name         = "root-ca"
#   key_vault_id = azurerm_key_vault.global.id

#   certificate_policy {
#     issuer_parameters {
#       name = "Self"
#     }

#     key_properties {
#       exportable = true
#       key_size   = 256
#       key_type   = "EC"
#       reuse_key  = true
# 			curve 		 = "P-256"
#     }

#     lifetime_action {
#       action {
#         action_type = "AutoRenew"
#       }

#       trigger {
#         days_before_expiry = 60
#       }
#     }

#     secret_properties {
#       content_type = "application/x-pem-file"
#     }

#     x509_certificate_properties {
#       # Server Authentication = 1.3.6.1.5.5.7.3.1
#       # Client Authentication = 1.3.6.1.5.5.7.3.2
#       extended_key_usage = ["1.3.6.1.5.5.7.3.1", "1.3.6.1.5.5.7.3.2"]

#       key_usage = [
#         "digitalSignature",
#         "keyCertSign",
#         "cRLSign",
#       ]

#       subject_alternative_names {
#         dns_names = ["ca.${azurerm_private_dns_zone.global.name}"]
#       }

#       subject            = "CN=ca.${azurerm_private_dns_zone.global.name}"
#       validity_in_months = 60
#     }
#   }
# 	lifecycle {
# 		ignore_changes = [
# 			certificate_policy[0].x509_certificate_properties[0].key_usage
# 		]
# 	}
# }
