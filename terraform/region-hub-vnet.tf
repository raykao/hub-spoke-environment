
resource "azurerm_virtual_network" "hub" {
	provider = azurerm.sub1
	name = "${local.prefix}hub-vnet"
	resource_group_name = azurerm_resource_group.hub.name
	location = azurerm_resource_group.hub.location
	address_space       = [var.hub_address_space]
}

resource azurerm_subnet firewall {
	provider = azurerm.sub1
	name = "AzureFirewallSubnet"
	resource_group_name  = azurerm_resource_group.hub.name
	virtual_network_name = azurerm_virtual_network.hub.name
	address_prefixes     = [cidrsubnet(azurerm_virtual_network.hub.address_space[0], 10, 0)]
}

resource azurerm_subnet vpn {
	provider = azurerm.sub1
	name = "GatewaySubnet"
	resource_group_name  = azurerm_resource_group.hub.name
	virtual_network_name = azurerm_virtual_network.hub.name
	address_prefixes     = [cidrsubnet(azurerm_virtual_network.hub.address_space[0], 8, 1)]
}

resource azurerm_subnet jumpbox {
	provider = azurerm.sub1
	name = "JumpboxSubnet"
	resource_group_name  = azurerm_resource_group.hub.name
	virtual_network_name = azurerm_virtual_network.hub.name
	address_prefixes     = [cidrsubnet(azurerm_virtual_network.hub.address_space[0], 8, 255)]
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

resource "azurerm_virtual_network_peering" "hubtospoke3" {
	provider = azurerm.sub1
	name                      = "hubtospoke3"
	resource_group_name       = azurerm_resource_group.hub.name
	virtual_network_name      = azurerm_virtual_network.hub.name
	remote_virtual_network_id = azurerm_virtual_network.spoke3.id
}