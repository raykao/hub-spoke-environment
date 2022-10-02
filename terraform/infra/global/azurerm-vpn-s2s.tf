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