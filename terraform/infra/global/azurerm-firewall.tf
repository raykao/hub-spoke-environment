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
        "*.opensuse.org",
				"aka.ms",
				"management.azure.com"
			]
    }
  }
}


resource "azurerm_firewall_policy_rule_collection_group" "spoke1" {
	name               = "spoke1-fwpolicy-rcg"
  firewall_policy_id = azurerm_firewall_policy.canadacentral.id
  priority           = 100

nat_rule_collection {
    name     = "jumpbox-ssh"
    priority = 300
    action   = "Dnat"
    rule {
      name                = "ssh"
      protocols           = ["TCP"]
      source_addresses    = ["*"]
      destination_address = azurerm_firewall.canadacentral.virtual_hub[0].public_ip_addresses[0]
      destination_ports   = ["2022"]
      translated_address  = "10.1.255.4"
      translated_port     = "2022"
    }
  }

	nat_rule_collection {
    name     = "jumpbox-xrdp"
    priority = 301
    action   = "Dnat"
    rule {
      name                = "xrdp"
      protocols           = ["TCP"]
      source_addresses    = ["*"]
      destination_address = azurerm_firewall.canadacentral.virtual_hub[0].public_ip_addresses[0]
      destination_ports   = ["2023"]
      translated_address  = "10.1.255.4"
      translated_port     = "2023"
    }
  }

	network_rule_collection {
		name = "jumpbox-allow-all-outbound"
		priority = 400
		action = "Allow"

		rule {
			name = "all"
			protocols = ["Any"]
			source_addresses = ["10.1.255.0/24"]
			destination_ports = ["*"]
			destination_addresses = ["*"]
		} 
	}

	application_rule_collection {
    name     = "ubuntuUpdates"
    priority = 500
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
				"10.1.0.0/16"
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

