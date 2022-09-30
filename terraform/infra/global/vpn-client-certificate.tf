resource "tls_private_key" "vpn-client-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_cert_request" "vpn-client-csr" {
  private_key_pem = tls_private_key.vpn-client-key.private_key_pem

  subject {
    common_name  = "client.${var.prefix}.${azurerm_private_dns_zone.global.name}"
    organization = azurerm_private_dns_zone.global.name
  }
}

resource "tls_locally_signed_cert" "vpn-client-signed-cert" {
  cert_request_pem   = tls_cert_request.vpn-client-csr.cert_request_pem
  ca_private_key_pem = tls_private_key.root-key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.root-ca.cert_pem

  validity_period_hours = 720

  allowed_uses = [
    "client_auth",
    "ipsec_user"
  ]
}

resource "local_file" "client-signed-cert" {
  content = tls_locally_signed_cert.vpn-client-signed-cert.cert_pem
  filename = "certs/client/cert.pem.crt"

  ## Possible way to generate pkcs12 cert for windows...but we can also use the PKCS12 provider from chilicat
  # provisioner "local-exec" {
  #   command = "openssl pkcs12 -export -in certs/client/cert.pem.crt -inkey certs/client/private.key -out certs/client/client.pfx -passout pass:mypassword"
  # }
}

resource "local_file" "client-key" {
  content = tls_private_key.vpn-client-key.private_key_pem
  filename = "certs/client/private.key"
}

resource "pkcs12_from_pem" "client-cert" {
  password = var.client_cert_password
  cert_pem = tls_locally_signed_cert.vpn-client-signed-cert.cert_pem
  private_key_pem = tls_private_key.vpn-client-key.private_key_pem
}

resource "local_file" "client-ca-signed-pkcs12-cert" {
  filename = "certs/client/client.pfx"
  content_base64 = pkcs12_from_pem.client-cert.result
}