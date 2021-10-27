variable "virtual_hub_regions" {
	type = list
	default = [
		"canadacentral",
		"southeastasia"
	]
}

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
  name                = "${each.key}-hub"
  resource_group_name = azurerm_resource_group.global.name
  location            = "${each.key}"
  virtual_wan_id      = azurerm_virtual_wan.global.id
  address_prefix      = "172.16.${each.value}.0/24"
}

output "virtual_hubs" {
	value = {
		for hub, obj in azurerm_virtual_hub.all : hub => obj
	}
}