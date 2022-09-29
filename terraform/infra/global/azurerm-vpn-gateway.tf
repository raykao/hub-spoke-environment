resource "random_string" "psk" {
 length = 32
 special = false
 upper = true
 lower = true
 numeric = true
}

resource "azurerm_vpn_gateway" "canadacentral" {
  name                = "canadacentral-vpngw"
  location            = "canadacentral"
  resource_group_name = azurerm_resource_group.global.name
  virtual_hub_id      = azurerm_virtual_hub.all["canadacentral"].id
}

resource "azurerm_vpn_site" "homelab1" {
  name                = "homelab1"
  resource_group_name = azurerm_resource_group.global.name
  location            = azurerm_vpn_gateway.canadacentral.location
  virtual_wan_id      = azurerm_virtual_wan.global.id

  address_cidrs = [var.onprem_cidr]

  link {
    name       = "home1"
    ip_address = data.http.myip.response_body
    speed_in_mbps = 100
  }
}

resource "azurerm_vpn_gateway_connection" "homelab1" {
  name               = "homelab1"
  vpn_gateway_id     = azurerm_vpn_gateway.canadacentral.id
  remote_vpn_site_id = azurerm_vpn_site.homelab1.id

  vpn_link {
    name             = "homelab1"
    vpn_site_link_id = azurerm_vpn_site.homelab1.link[0].id
    bandwidth_mbps = 100
    protocol = "IKEv2"
    shared_key = random_string.psk.result
  }
}

resource "azurerm_vpn_server_configuration" "p2s" {
  name                     = "point-to-site-config"
  resource_group_name      = azurerm_resource_group.global.name
  location                 = azurerm_resource_group.global.location
  vpn_authentication_types = ["Certificate"]

  client_root_certificate {
    name             = "Internal-Root-CA"
    public_cert_data = trimspace(trimprefix(trimsuffix(trimspace(tls_self_signed_cert.root-ca.cert_pem), "-----END CERTIFICATE-----"), "-----BEGIN CERTIFICATE-----"))
  }
}

resource "azurerm_point_to_site_vpn_gateway" "canadacentral" {
  name                        = "canadacentral-p2s-vpn-gateway"
  location                    = azurerm_resource_group.global.location
  resource_group_name         = azurerm_resource_group.global.name
  virtual_hub_id              = azurerm_virtual_hub.all["canadacentral"].id
  vpn_server_configuration_id = azurerm_vpn_server_configuration.p2s.id
  scale_unit                  = 1
  connection_configuration {
    name = "canadacentral-gateway-config"

    internet_security_enabled = true

    route {
      # associated_route_table_id = azurerm_virtual_hub_route_table.default.id
      associated_route_table_id = "${azurerm_virtual_hub.all["canadacentral"].id}/hubRouteTables/DefaultRouteTable"
      propagated_route_table {
        ids = [
          # azurerm_virtual_hub_route_table.default.id
          "${azurerm_virtual_hub.all["canadacentral"].id}/hubRouteTables/DefaultRouteTable"
        ]
      }
    }

    vpn_client_address_pool {
      address_prefixes = [
        "172.17.0.0/24"
      ]
    }
  }
}

