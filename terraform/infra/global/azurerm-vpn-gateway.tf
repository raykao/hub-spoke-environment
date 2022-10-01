resource "random_string" "psk" {
 length = 32
 special = false
 upper = true
 lower = true
 numeric = true
}

resource "azurerm_vpn_gateway" "s2s" {
  for_each = {
		for idx, region in var.virtual_hub_regions: region => idx
	}
  name                = "${each.key}-s2s-vpngw"
  location            = each.key
  resource_group_name = azurerm_resource_group.global.name
  virtual_hub_id      = azurerm_virtual_hub.all[each.key].id
}

resource "azurerm_vpn_site" "s2s" {
  for_each = {
		for idx, region in var.virtual_hub_regions: region => idx
	}

  name                = "lab${each.value}"
  resource_group_name = azurerm_resource_group.global.name
  location            = azurerm_vpn_gateway.s2s[each.key].location
  virtual_wan_id      = azurerm_virtual_wan.global.id
  
  address_cidrs = [var.onprem_cidr]

  link {
    name       = "home${each.value}"
    ip_address = data.http.myip.response_body
    speed_in_mbps = 100
  }
}

resource "azurerm_vpn_gateway_connection" "s2s" {
  for_each = {
		for idx, region in var.virtual_hub_regions: region => idx
	}
  name               = "lab${each.value}"
  vpn_gateway_id     = azurerm_vpn_gateway.s2s[each.key].id
  remote_vpn_site_id = azurerm_vpn_site.s2s[each.key].id

  internet_security_enabled = true
  
  vpn_link {
    name             = "homelab${each.value}"
    vpn_site_link_id = azurerm_vpn_site.s2s[each.key].link[0].id
    bandwidth_mbps = 100
    protocol = "IKEv2"
    shared_key = random_string.psk.result
  }
}

resource "azurerm_vpn_server_configuration" "p2s" {
  for_each = {
		for idx, region in var.virtual_hub_regions: region => idx
	}
  name                     = "${each.key}-p2s-config"
  resource_group_name      = azurerm_resource_group.global.name
  location                 = azurerm_resource_group.global.location
  vpn_authentication_types = ["Certificate"]


  client_root_certificate {
    name             = "Internal-Root-CA"
    public_cert_data = trimspace(trimprefix(trimsuffix(trimspace(tls_self_signed_cert.root-ca.cert_pem), "-----END CERTIFICATE-----"), "-----BEGIN CERTIFICATE-----"))
  }
}

resource "azurerm_point_to_site_vpn_gateway" "p2s" {
  for_each = {
		for idx, region in var.virtual_hub_regions: region => idx
	}
  name                        = "${each.key}-p2s-vpn-gw"
  location                    = each.key
  resource_group_name         = azurerm_resource_group.global.name
  virtual_hub_id              = azurerm_virtual_hub.all[each.key].id
  vpn_server_configuration_id = azurerm_vpn_server_configuration.p2s[each.key].id
  scale_unit                  = 1
  connection_configuration {
    name = "${each.key}-p2s-gw"

    internet_security_enabled = true

    # route {
    #   # associated_route_table_id = azurerm_virtual_hub_route_table.default.id
    #   associated_route_table_id = "${azurerm_virtual_hub.all["canadacentral"].id}/hubRouteTables/defaultRouteTable"
    #   propagated_route_table {
    #     ids = [
    #       # azurerm_virtual_hub_route_table.default.id
    #       "${azurerm_virtual_hub.all["canadacentral"].id}/hubRouteTables/DefaultRouteTable"
    #     ]
    #     labels = [
    #       "default"
    #     ]
    #   }
    # }

    vpn_client_address_pool {
      address_prefixes = [
        "172.17.${each.value}.0/24"
      ]
    }
  }
}

