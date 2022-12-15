# resource "tls_private_key" "ca" {
#   algorithm   = "RSA"
#   rsa_bits = "2048"
# }

# # resource "local_file" "id_rsa" {
# #   filename = "certs/${terraform.workspace}/global/id_rsa"
# #   content  = tls_private_key.ca.private_key_pem
# #   file_permission = "0600"
# # }

# # resource "local_file" "id_rsa-pub" {
# #   filename = "certs/${terraform.workspace}/global/id_rsa.pub"
# #   content  = tls_private_key.ca.public_key_openssh
# #   file_permission = "0600"
# # }

# resource "tls_self_signed_cert" "ca" {
#   key_algorithm   = "ECDSA"
#   private_key_pem = "${file(\"private_key.pem\")}"

#   subject {
#     common_name  = "example.com"
#     organization = "ACME Examples, Inc"
#   }

#   validity_period_hours = 12

#   allowed_uses = [
#     "key_encipherment",
#     "digital_signature",
#     "server_auth",
#     "cert_signing",
#     "crl_signing",
#   ]
# }