resource "azurerm_virtual_wan" "global" {
  name                = "global-vwan"
  resource_group_name = azurerm_resource_group.global.name
  location            = azurerm_resource_group.global.location
	type = "Standard"
}

resource "azurerm_virtual_hub" "all" {
	for_each = {
		for idx, region in var.virtual_hub_regions: region => idx
	}
	name                = each.key
	resource_group_name = azurerm_resource_group.global.name
	location            = each.key
	virtual_wan_id      = azurerm_virtual_wan.global.id
	address_prefix      = "172.16.${each.value}.0/24"
}

# This will auto forcetunnel/secure all connected networks through the AzFW in given Hub
# Must associate with the defualt rote table and name it "public_traffic"
resource "azurerm_virtual_hub_route_table_route" "default" {
	for_each = {
		for idx, region in var.virtual_hub_regions: region => idx
	}
	
	route_table_id = azurerm_virtual_hub.all[each.key].default_route_table_id

	name              = "public_traffic"
	destinations_type = "CIDR"
	destinations      = ["0.0.0.0/0"]
	next_hop_type     = "ResourceId"
	next_hop          = azurerm_firewall.hubs[each.key].id
}