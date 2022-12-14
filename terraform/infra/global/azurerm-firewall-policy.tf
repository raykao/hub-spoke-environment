resource "azurerm_firewall_policy" "hubs" {
  for_each = {
		for idx, region in var.virtual_hub_regions: region => idx
	}
  name                = "${each.key}FwPolicy"
  resource_group_name = azurerm_resource_group.global.name
  location            = "${each.key}"

  dns {
	  proxy_enabled = true
  }
}