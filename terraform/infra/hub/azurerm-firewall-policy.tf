resource "azurerm_firewall_policy" "hub" {
  name                = "hubVnetFwPolicy"
  resource_group_name = azurerm_resource_group.hub.name
  location            = var.location
  base_policy_id = var.firewall_policy_id

  dns {
	proxy_enabled = true
  }
}