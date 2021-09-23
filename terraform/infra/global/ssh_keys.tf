resource "tls_private_key" "ssh" {
  algorithm   = "RSA"
  rsa_bits = "2048"
}

resource "local_file" "id_rsa" {
  filename = "certs/${terraform.workspace}/global/id_rsa"
  content  = tls_private_key.ssh.private_key_pem
  file_permission = "0600"
}

resource "local_file" "id_rsa-pub" {
  filename = "certs/${terraform.workspace}/global/id_rsa.pub"
  content  = tls_private_key.ssh.public_key_openssh
  file_permission = "0600"
}