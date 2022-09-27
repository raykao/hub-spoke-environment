resource "tls_private_key" "root-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "root-ca" {
  private_key_pem = tls_private_key.root-key.private_key_pem

  subject {
    common_name  = azurerm_private_dns_zone.global.name
    organization = "Internal Root CA - Self Signed Cert Example"
  }

  validity_period_hours = 175320

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}