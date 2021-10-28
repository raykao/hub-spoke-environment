resource "azurerm_firewall" "canadacentral" {
	
	name                = "${local.prefix}-global-canadacentral-fw"
	location            = "canadacentral"
	resource_group_name = azurerm_resource_group.global.name

	sku_name = "AZFW_Hub"
	sku_tier = "Standard"

	firewall_policy_id = azurerm_firewall_policy.canadacentral.id

	threat_intel_mode = ""

	virtual_hub {
		virtual_hub_id = azurerm_virtual_hub.all["canadacentral"].id
		public_ip_count = 1
	}
}

resource "azurerm_firewall_policy" "canadacentral" {
  name                = "canadacentralFwPolicy"
  resource_group_name = azurerm_resource_group.global.name
  location            = "canadacentral"
}

resource "azurerm_firewall_policy_rule_collection_group" "canadacentral" {
	name               = "canadacentral-fwpolicy-rcg"
  firewall_policy_id = azurerm_firewall_policy.canadacentral.id
  priority           = 500

	application_rule_collection {
    name     = "ubuntuUpdates"
    priority = 100
    action   = "Allow"

    rule {
      name = "app_rule_collection1_rule1"
      
			protocols {
        type = "Http"
        port = 80
      }

      protocols {
        type = "Https"
        port = 443
      }
      
			source_addresses  = [
				"*"
			]
      
			destination_fqdns = [
				"*.ubuntu.com",
				"*.archive.ubuntu.com",
				"*.azure.archive.ubuntu.com",
				"apt.releases.hashicorp.com",
				"*.microsoft.com",
				"aka.ms",
				"management.azure.com"
			]
    }
  }
}