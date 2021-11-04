resource "random_string" "psk" {
 length = 32
 special = false
 upper = true
 lower = true
 number = true
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

  address_cidrs = ["192.168.1.0/24"]

  link {
    name       = "home1"
    ip_address = data.http.myip.body
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