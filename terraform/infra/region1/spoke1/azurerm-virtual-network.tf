resource "azurerm_virtual_network" "spoke" {
	name = "${local.prefix}-vnet"
	resource_group_name = azurerm_resource_group.spoke.name
	location = azurerm_resource_group.spoke.location
	address_space       = [
		var.address_space
	]
	dns_servers = var.dns_servers
}

resource "azurerm_subnet" "aks-ilb" {
	name = "AksIlbSubnet"
	resource_group_name  = azurerm_resource_group.spoke.name
	virtual_network_name = azurerm_virtual_network.spoke.name
	address_prefixes     = [cidrsubnet(var.address_space, 4, 0)]
}

resource azurerm_subnet aks1 {
	name = "Aks1Subnet"
	resource_group_name  = azurerm_resource_group.spoke.name
	virtual_network_name = azurerm_virtual_network.spoke.name
	address_prefixes     = [cidrsubnet(var.address_space, 1, 1)]
	private_endpoint_network_policies_enabled = true
}