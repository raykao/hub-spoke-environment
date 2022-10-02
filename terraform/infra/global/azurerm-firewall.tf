resource "azurerm_firewall" "hubs" {
	for_each = {
		for idx, region in var.virtual_hub_regions: region => idx
	}

	name                = "${local.prefix}-global-${each.key}-fw"
	location            = "${each.key}"
	resource_group_name = azurerm_resource_group.global.name

	sku_name = "AZFW_Hub"
	sku_tier = "Standard"

	firewall_policy_id = azurerm_firewall_policy.hubs["${each.key}"].id

	virtual_hub {
		virtual_hub_id = azurerm_virtual_hub.all["${each.key}"].id
		public_ip_count = 1
	}
}

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