resource "azurerm_firewall_policy_rule_collection_group" "hubs" {
  for_each = {
		for idx, region in var.virtual_hub_regions: region => idx
	}

	name               = "fwpolicy-global-default-${each.key}-rcg"
	firewall_policy_id = azurerm_firewall_policy.hubs["${each.key}"].id
  	priority           = 100

	network_rule_collection {
		name = "p2s-vpn-allow-all-outbound"
		priority = 100
		action = "Allow"

		rule {
			name = "all"
			protocols = ["Any"]
			source_addresses = azurerm_point_to_site_vpn_gateway.p2s[each.key].connection_configuration[0].vpn_client_address_pool[0].address_prefixes
			destination_ports = ["*"]
			destination_addresses = ["*"]
		} 
	}

    network_rule_collection {
	  name = "ntp"
	  priority = 105
	  action = "Allow"

	  rule {
		name = "ntp"

		protocols = ["UDP"]
		source_addresses = ["*"]
		destination_ports = ["123"]
		destination_fqdns= [
			"ntp.ubuntu.com"
		]
	  }
	}

	application_rule_collection {
		name     = "azure"
		priority = 110
		action   = "Allow"

		rule {
			name = "app_rule_collection1_rule1"

			protocols {
				type = "Https"
				port = 443
			}
			
			source_addresses  = [
				"*"
			]

			destination_fqdns = [
				"*.microsoft.com",
				"management.azure.com",
			]
		}
	}

	application_rule_collection {
		name     = "ubuntu"
		priority = 200
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
				"api.snapcraft.io"
			]
    	}
  	}

	application_rule_collection {
		name     = "suse"
		priority = 205
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
				"*.opensuse.org",
			]
		}
	}

	application_rule_collection {
		name     = "hashicorp"
		priority = 300
		action   = "Allow"

		rule {
			name = "app_rule_collection1_rule1"
			
			protocols {
				type = "Https"
				port = 443
			}
			
			source_addresses  = [
				"*"
			]

			destination_fqdns = [
				"*.hashicorp.com",
				"apt.releases.hashicorp.com",
			]
		}
	}
}