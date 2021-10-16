resource "azurerm_public_ip" "vpngateway" {
	
	name                = "${local.prefix}-hub-vpn-pip"
	resource_group_name = azurerm_resource_group.hub.name
	location            = azurerm_resource_group.hub.location
	allocation_method   = "Static"
	sku 				= "Standard"
  	domain_name_label = "${local.prefix}-hub-vpn"
}

resource "tls_private_key" "ca" {
  algorithm   = "RSA"
  rsa_bits = 2048
}

resource "tls_self_signed_cert" "ca" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.ca.private_key_pem

  is_ca_certificate = true

  subject {
    common_name  = var.domain
    organization = "Ray Kao"
  }

  dns_names = [ azurerm_public_ip.vpngateway.fqdn ]

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

resource "local_file" "ca_pem" {
  filename = "certs/${terraform.workspace}/hub/caCert.pem"
  content  = tls_self_signed_cert.ca.cert_pem
  file_permission = "0640"
}

resource "null_resource" "cert_encode" {
  depends_on =  [ local_file.ca_pem ]
  
  provisioner "local-exec" {
      command = "openssl x509 -in certs/${terraform.workspace}/hub/caCert.pem -outform der | if [[ \"$(uname)\" = \"Darwin\" ]]; then base64 > certs/${terraform.workspace}/hub/caCert.der; else base64 -w0 > certs/${terraform.workspace}/hub/caCert.der; fi"
  }
}

data "local_file" "ca_der" {
  filename = "certs/${terraform.workspace}/hub/caCert.der"
  depends_on = [
    null_resource.cert_encode
  ]
}

resource "azurerm_virtual_network_gateway" "default" {
  depends_on = [
    azurerm_subnet.firewall,
    azurerm_subnet.consul,
    azurerm_subnet.nomad,
    azurerm_subnet.vault,
    azurerm_subnet.prometheus,
    azurerm_subnet.vpn,
    azurerm_subnet.dns,
    azurerm_subnet.jumpbox,
    azurerm_firewall.hub
  ]
	
  name                = "${local.prefix}-vpn"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku = "VpnGw1AZ"
  generation = "Generation1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpngateway.id
    subnet_id                     = azurerm_subnet.vpn.id
    private_ip_address_allocation = "Dynamic"
  }

  vpn_client_configuration {
    address_space = ["172.16.201.0/24"]

    root_certificate {
      name = "VPNRoot"
      public_cert_data = data.local_file.ca_der.content
    }
  }
}