resource "azurerm_virtual_network" "spoke" {
	name = "${local.prefix}-vnet"
	resource_group_name = azurerm_resource_group.spoke.name
	location = azurerm_resource_group.spoke.location
	address_space       = [var.address_space]
	dns_servers = var.hub.vnet.dns_servers
}

resource "azurerm_subnet" "default" {
	name = "Default"
	resource_group_name  = azurerm_resource_group.spoke.name
	virtual_network_name = azurerm_virtual_network.spoke.name
	address_prefixes     = [cidrsubnet(azurerm_virtual_network.spoke.address_space[0], 8, 0)]
}

resource "azurerm_subnet" "aks1" {
	name = "Aks1Subnet"
	resource_group_name  = azurerm_resource_group.spoke.name
	virtual_network_name = azurerm_virtual_network.spoke.name
	address_prefixes     = [cidrsubnet(azurerm_virtual_network.spoke.address_space[0], 6, 1)]
	enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "jumpbox" {
	name = "JumpboxSubnet"
	resource_group_name  = azurerm_resource_group.spoke.name
	virtual_network_name = azurerm_virtual_network.spoke.name
	address_prefixes     = [cidrsubnet(azurerm_virtual_network.spoke.address_space[0], 8, 255)]
}