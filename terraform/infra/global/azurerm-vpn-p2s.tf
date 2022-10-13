
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
        "172.26.${each.value}.0/24"
      ]
    }
  }
}

