
resource "azurerm_virtual_network" "hub" {
	
	name = "${local.prefix}hub-vnet"
	resource_group_name = azurerm_resource_group.hub.name
	location = azurerm_resource_group.hub.location
	address_space       = [var.address_space]
	dns_servers = [
		cidrhost(local.bind9_address_space, 4),
		cidrhost(local.bind9_address_space, 5),
		cidrhost(local.bind9_address_space, 6),
		"168.63.129.16"
	]
}

resource azurerm_subnet firewall {
	
	name = "AzureFirewallSubnet"
	resource_group_name  = azurerm_resource_group.hub.name
	virtual_network_name = azurerm_virtual_network.hub.name
	address_prefixes     = [cidrsubnet(var.address_space, 10, 0)]
}

resource azurerm_subnet vpn {
	
	name = "GatewaySubnet"
	resource_group_name  = azurerm_resource_group.hub.name
	virtual_network_name = azurerm_virtual_network.hub.name
	address_prefixes     = [cidrsubnet(var.address_space, 8, 1)]
}

resource azurerm_subnet dns {
  name = "DnsSubnet"
  resource_group_name =  azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes = [local.bind9_address_space]
}

resource azurerm_subnet prometheus {
  name = "PrometheusSubnet"
  resource_group_name =  azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes = [cidrsubnet(var.address_space, 8, 3)]
}

resource azurerm_subnet consul {
  name = "ConsulSubnet"
  resource_group_name =  azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes = [cidrsubnet(var.address_space, 8, 4)]
}

resource azurerm_subnet jumpbox {
	
	name = "JumpboxSubnet"
	resource_group_name  = azurerm_resource_group.hub.name
	virtual_network_name = azurerm_virtual_network.hub.name
	address_prefixes     = [cidrsubnet(var.address_space, 8, 255)]
}