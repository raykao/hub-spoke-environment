resource "tls_private_key" "vpn-client-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_cert_request" "vpn-client-csr" {
  private_key_pem = tls_private_key.vpn-client-key.private_key_pem

  subject {
    common_name  = "client1.${azurerm_private_dns_zone.global.name}"
    organization = "Internal Root CA - Self Signed Cert Example - Client"
  }
}

resource "tls_locally_signed_cert" "vpn-client-signed-cert" {
  cert_request_pem   = tls_cert_request.vpn-client-csr.cert_request_pem
  ca_private_key_pem = tls_private_key.root-key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.root-ca.cert_pem

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "local_file" "client-signed-cert" {
  content = tls_locally_signed_cert.vpn-client-signed-cert.cert_pem
  filename = "certs/client/cert.pem.crt"
}

resource "local_file" "client-key" {
  content = tls_private_key.vpn-client-key.private_key_pem
  filename = "certs/client/private.key"
}