seal "azurekeyvault" {
  tenant_id      = "${var.tenant_id}"
  client_id      = "${var.client_id}"
  client_secret  = "${var.client_secret}"
  vault_name     = "${var.vault_name}"
  key_name       = "${var.key_name}"
}

storage "postgresql" {
  connection_url = "postgres://${var.postgres_admin_username}:${var.postgres_admin_password}@${var.postgres_host}:5432/vault?sslmode=verify-full"
}

listener "tcp" {
  "address" = "0.0.0.0:8200",
  "tls_disable" = true
}