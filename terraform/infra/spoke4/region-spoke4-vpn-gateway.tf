resource "azurerm_public_ip" "spoke4-vpngateway" {
	provider = azurerm.sub1
	name                = "${local.prefix}-spoke4-vpn-pip"
	resource_group_name = azurerm_resource_group.spoke4.name
	location            = azurerm_resource_group.spoke4.location
	allocation_method   = "Static"
	sku 				= "Standard"
  	domain_name_label = "${local.prefix}-spoke4-vpn"
}

resource "tls_private_key" "spoke4-ca" {
  algorithm   = "RSA"
  rsa_bits = 2048
}

resource "tls_self_signed_cert" "spoke4-ca" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.spoke4-ca.private_key_pem

  is_ca_certificate = true

  subject {
    common_name  = var.domain
    organization = "Ray Kao"
  }

  dns_names = [ azurerm_public_ip.spoke4-vpngateway.fqdn ]

  validity_period_hours = 4380

  allowed_uses = [
    "key_encipherment",
    "data_encipherment",
    "digital_signature",
    "server_auth",
    "cert_signing",
    "ipsec_tunnel",
    "ipsec_user",
    "crl_signing"
  ]
}

resource "local_file" "spoke4-ca_pem" {
  filename = "certs/${terraform.workspace}/spoke4/spoke4-caCert.pem"
  content  = tls_self_signed_cert.spoke4-ca.cert_pem
  file_permission = "0640"
}

resource "null_resource" "spoke4-cert_encode" {
  depends_on =  [ local_file.spoke4-ca_pem ]
  
  provisioner "local-exec" {
      command = "openssl x509 -in certs/${terraform.workspace}/spoke4/spoke4-caCert.pem -outform der | if [[ \"$(uname)\" = \"Darwin\" ]]; then base64 > certs/${terraform.workspace}/spoke4/spoke4-caCert.der; else base64 -w0 > certs/${terraform.workspace}/spoke4/spoke4-caCert.der; fi"
  }
}

data "local_file" "spoke4-ca_der" {
  filename = "certs/${terraform.workspace}/spoke4/spoke4-caCert.der"
  depends_on = [
    null_resource.spoke4-cert_encode
  ]
}

resource "azurerm_virtual_network_gateway" "spoke4" {
	provider = azurerm.sub1
  name                = "${local.prefix}-spoke4-vpn"
  location            = azurerm_resource_group.spoke4.location
  resource_group_name = azurerm_resource_group.spoke4.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku = "VpnGw1AZ"
  generation = "Generation1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.spoke4-vpngateway.id
    subnet_id                     = azurerm_subnet.spoke4-vpn.id
    private_ip_address_allocation = "Dynamic"
  }

  vpn_client_configuration {
    address_space = ["172.16.202.0/24"]

    root_certificate {
      name = "VPNRoot"
      public_cert_data = data.local_file.spoke4-ca_der.content
    }
  }
}