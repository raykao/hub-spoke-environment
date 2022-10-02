resource "tls_private_key" "ssh" {
  count = local.create_public_key ? 1 : 0
  
  algorithm   = "RSA"
  rsa_bits = "2048"
}

resource "local_file" "id_rsa" {
  count = local.create_public_key ? 1 : 0
  
  filename = "certs/jumpbox/${local.name}/id_rsa"
  content  = tls_private_key.ssh[0].private_key_pem
  file_permission = "0600"
}

resource "local_file" "id_rsa-pub" {
  count = local.create_public_key ? 1 : 0

  filename = "certs/jumpbox/${local.name}/id_rsa.pub"
  content  = tls_private_key.ssh[0].public_key_openssh
  file_permission = "0600"
}

# resource "time_sleep" "wait_for_key_vault_policies" {
#   depends_on = [
#     azurerm_key_vault_access_policy.user-global
#   ]

#   create_duration = "30s"
# }

# resource "azurerm_key_vault_secret" "jumpboxSshPrivKey" {
#   depends_on = [
#     time_sleep.wait_for_key_vault_policies
#   ]
#   name         = "jumpboxSshPrivKey"
#   value        = tls_private_key.ssh.private_key_pem
#   key_vault_id = azurerm_key_vault.global.id
# }

# resource "azurerm_key_vault_secret" "jumpboxSshPubKey" {
#   depends_on = [
#     time_sleep.wait_for_key_vault_policies
#   ]
#   name         = "jumpboxSshPubKey"
#   value        = tls_private_key.ssh.public_key_openssh
#   key_vault_id = azurerm_key_vault.global.id
# }