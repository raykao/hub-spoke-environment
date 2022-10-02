resource "tls_private_key" "root-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "root-ca" {
  private_key_pem = tls_private_key.root-key.private_key_pem

  subject {
    common_name  = "ca.${var.prefix}.${azurerm_private_dns_zone.global.name}"
    organization = azurerm_private_dns_zone.global.name
  }

  is_ca_certificate = true
  validity_period_hours = 175320

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing"
  ]
}

resource "local_file" "rootca" {
  content = tls_self_signed_cert.root-ca.cert_pem
  filename = "certs/rootca/ca.pem"
}

resource "local_file" "rootkey" {
  content = tls_self_signed_cert.root-ca.private_key_pem
  filename = "certs/rootca/key.pem"
}