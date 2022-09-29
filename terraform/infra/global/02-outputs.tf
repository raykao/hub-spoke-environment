output "prefix" {
	value = var.prefix
}

output "resource_group" {
	value = azurerm_resource_group.global
}

output "contributor_msi" {
	value = azurerm_user_assigned_identity.contributor
}

output "public_key" {
	value = local_file.id_rsa-pub.content
}

output "private_dns_zone" {
	value = azurerm_private_dns_zone.global
}

output "public_dns_zone" {
	value = azurerm_dns_zone.global
}

output "admin_email" {
	value = var.admin_email
}

output "vpn_psk" {
	value = random_string.psk.result
}

output "vpn_ip" {
	value = [
		tolist(azurerm_vpn_gateway.canadacentral.bgp_settings[0].instance_0_bgp_peering_address[0].tunnel_ips)[1], 
		tolist(azurerm_vpn_gateway.canadacentral.bgp_settings[0].instance_1_bgp_peering_address[0].tunnel_ips)[1]
	]
}

output "firewall_policy" {
	value = {
		canadacentral = azurerm_firewall_policy.canadacentral.id
	}
}

output "route_tables" {
	value = {
		canadacentral-default = "${azurerm_virtual_hub.all["canadacentral"].id}/hubRouteTables/DefaultRouteTable"
	}
}

output "virtual_hubs" {
	value = {
		for hub, obj in azurerm_virtual_hub.all : hub => obj
	}
}