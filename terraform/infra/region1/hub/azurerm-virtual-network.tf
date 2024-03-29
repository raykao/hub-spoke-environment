resource "azurerm_virtual_network" "hub" {
	name = "${local.prefix}-vnet"
	resource_group_name = azurerm_resource_group.hub.name
	location = azurerm_resource_group.hub.location
	address_space       = [var.address_space]
}

resource azurerm_subnet pe {
  name = "PrivateEndpointSubnet"
  resource_group_name =  azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes = [cidrsubnet(var.address_space, 4, 0)]
}

resource azurerm_subnet consul {
  name = "ConsulSubnet"
  resource_group_name =  azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes = [cidrsubnet(var.address_space, 4, 1)]
}

resource azurerm_subnet nomad {
  name = "NomadSubnet"
  resource_group_name =  azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes = [cidrsubnet(var.address_space, 4, 2)]
}

resource azurerm_subnet vault {
  name = "VaultSubnet"
  resource_group_name =  azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes = [cidrsubnet(var.address_space, 4, 3)]
	service_endpoints    = ["Microsoft.Storage"]
	private_endpoint_network_policies_enabled = true
}

resource azurerm_subnet pki {
  name = "PkiSubnet"
  resource_group_name =  azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes = [cidrsubnet(var.address_space, 4, 4)]
	service_endpoints    = ["Microsoft.Storage"]
	private_endpoint_network_policies_enabled = true
}

resource azurerm_subnet prometheus {
  name = "PrometheusSubnet"
  resource_group_name =  azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes = [cidrsubnet(var.address_space, 4, 5)]
}


resource azurerm_subnet dns_resolver_in {
  name                 = "DnsResolverInBoundSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [cidrsubnet(var.address_space, 4, 6)]

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

resource azurerm_subnet dns_resolver_out {
  name                 = "DnsResolverOutBoundSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [cidrsubnet(var.address_space, 4, 7)]

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

resource azurerm_subnet jumpbox {
	name = "JumpboxSubnet"
	resource_group_name  = azurerm_resource_group.hub.name
	virtual_network_name = azurerm_virtual_network.hub.name
	address_prefixes     = [cidrsubnet(var.address_space, 4, 8)]
}