resource "azurerm_firewall_policy_rule_collection_group" "vpn-p2s" {
  for_each = {
		for idx, region in var.virtual_hub_regions: region => idx
	}
	name               = "vpn-p2s-fwpolicy-${each.key}-rcg"
  	firewall_policy_id = azurerm_firewall_policy.hubs[each.key].id
  	priority           = 300

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
}