output "prefix" {
	value = var.prefix
}

output "resource_group" {
	value = azurerm_resource_group.global
}

output "global_private_zone" {
	value = {
		name = azurerm_private_dns_zone.global.name
		resource_group_name = azurerm_private_dns_zone.global.resource_group_name
	}
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

# output "vpn_ip" {
# 	value = [
# 		for idx, region in var.virtual_hub_regions: azurerm_vpn_gateway.all["${region}"].name => idx
# 	]
# 	tolist(azurerm_vpn_gateway.canadacentral.bgp_settings[0].instance_0_bgp_peering_address[0].tunnel_ips)[1], 
# 		tolist(azurerm_vpn_gateway.canadacentral.bgp_settings[0].instance_1_bgp_peering_address[0].tunnel_ips)[1]
# }

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

output "firewall_ips" {
	value = {
		for region, fw in azurerm_firewall.hubs: region => flatten(fw.virtual_hub[0].public_ip_addresses)
	}
}

output "firewall_policy_ids" {
	value = {
		for k, instance in azurerm_firewall_policy.hubs: instance.location => azurerm_firewall_policy.hubs["${instance.location}"].id
	}
}

output "private_dns_zone_ids" {
	value = [
		azurerm_private_dns_zone.global.id
	]
}

output "private_dns_zones" {
  value = {
	keyvault 	= azurerm_private_dns_zone.keyvault
	mysql 		= azurerm_private_dns_zone.mysql
	pgsql		= azurerm_private_dns_zone.pgsql
  }
}