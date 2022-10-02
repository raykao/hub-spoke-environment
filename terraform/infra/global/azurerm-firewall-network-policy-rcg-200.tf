
resource "azurerm_firewall_policy_rule_collection_group" "jumpbox" {
	name               = "jumpbox-${var.virtual_hub_regions[0]}-fwpolicy-rcg"
  	firewall_policy_id = azurerm_firewall_policy.hubs[var.virtual_hub_regions[0]].id
  	priority           = 200
	
	network_rule_collection {
		name = "allow-jumpbox-all-outbound"
		priority = 100
		action = "Allow"

		rule {
			name = "all"
			protocols = ["Any"]
			source_addresses = [
				var.jumpbox_cidr
			]
			destination_ports = ["*"]
			destination_addresses = ["*"]
		} 
	}

	# nat_rule_collection {
	# 	name     = "jumpbox-ssh"
	# 	priority = 300
	# 	action   = "Dnat"
	# 	rule {
	# 		name                = "ssh"
	# 		protocols           = ["TCP"]
	# 		source_addresses    = ["*"]
	# 		destination_address = azurerm_firewall.hubs["canadacentral"].virtual_hub[0].public_ip_addresses[0]
	# 		destination_ports   = ["2022"]
	# 		translated_address  = "10.1.255.4"
	# 		translated_port     = "2022"
	# 	}
	# }

	# nat_rule_collection {
	# 	name     = "jumpbox-xrdp"
	# 	priority = 301
	# 	action   = "Dnat"
	# 	rule {
	# 		name                = "xrdp"
	# 		protocols           = ["TCP"]
	# 		source_addresses    = ["*"]
	# 		destination_address = azurerm_firewall.hubs["canadacentral"].virtual_hub[0].public_ip_addresses[0]
	# 		destination_ports   = ["2023"]
	# 		translated_address  = "10.1.255.4"
	# 		translated_port     = "2023"
	# 	}
	# }
}
