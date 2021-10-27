resource "azurerm_firewall" "canadacentral" {
	
	name                = "${local.prefix}-global-canadacentral-fw"
	location            = "canadacentral"
	resource_group_name = azurerm_resource_group.global.name

	sku_name = "AZFW_Hub"
	sku_tier = "Standard"

	threat_intel_mode = ""

	virtual_hub {
		virtual_hub_id = azurerm_virtual_hub.all["canadacentral"].id
		public_ip_count = 1
	}

}