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
	name                = "${each.key}"
	resource_group_name = azurerm_resource_group.global.name
	location            = "${each.key}"
	virtual_wan_id      = azurerm_virtual_wan.global.id
	address_prefix      = "172.16.${each.value}.0/24"
}

# resource "azurerm_virtual_hub_route_table_route" "default" {
#   route_table_id = "${azurerm_virtual_hub.all["canadacentral"].id}/hubRouteTables/DefaultRouteTable"

#   name              = "public-internet"
#   destinations_type = "CIDR"
#   destinations      = ["0.0.0.0/0"]
#   next_hop_type     = "ResourceId"
#   next_hop          = azurerm_firewall.canadacentral.id
# }

# resource "azurerm_virtual_hub_route_table" "canadacentral-default" {
#   name           = "canadacentral-default-vhubroutetable"
#   virtual_hub_id = azurerm_virtual_hub.all["canadacentral"].id
#   labels         = ["default"]
# }

# resource "azurerm_virtual_hub_route_table_route" "canada-default" {
#   route_table_id = azurerm_virtual_hub_route_table.canadacentral-default.id

#   name              = "default-route"
#   destinations_type = "CIDR"
#   destinations      = ["0.0.0.0/1", "128.0.0.0/1"]
#   next_hop_type     = "ResourceId"
#   next_hop          = azurerm_firewall.canadacentral.id
# }

# resource "azurerm_virtual_hub_route_table" "default" {
#   name           = "DefaultRouteTable"
#   virtual_hub_id = azurerm_virtual_hub.all["canadacentral"].id
#   labels         = ["default"]
# }