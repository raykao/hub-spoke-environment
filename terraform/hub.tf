resource "azurerm_resource_group" "hub" {
	provider = azurerm.sub1
  	name = "${local.prefix}hub-rg"
  	location = local.location
}

resource "azurerm_virtual_network" "hub" {
	provider = azurerm.sub1
	name = "${local.prefix}hub-vnet"
	resource_group_name = azurerm_resource_group.hub.name
	location = azurerm_resource_group.hub.location
	address_space       = [var.hub_address_space]
}

resource azurerm_subnet default {
	provider = azurerm.sub1
	name = "default"
	resource_group_name  = azurerm_resource_group.hub.name
	virtual_network_name = azurerm_virtual_network.hub.name
	address_prefixes     = [cidrsubnet(azurerm_virtual_network.hub.address_space[0], 6, 0)]
}

resource "azurerm_virtual_network_peering" "hubtospoke1" {
	provider = azurerm.sub1
	name                      = "hubtospoke1"
	resource_group_name       = azurerm_resource_group.hub.name
	virtual_network_name      = azurerm_virtual_network.hub.name
	remote_virtual_network_id = azurerm_virtual_network.spoke1.id
}

resource "azurerm_virtual_network_peering" "hubtospoke2" {
	provider = azurerm.sub1
	name                      = "hubtospoke2"
	resource_group_name       = azurerm_resource_group.hub.name
	virtual_network_name      = azurerm_virtual_network.hub.name
	remote_virtual_network_id = azurerm_virtual_network.spoke2.id
}