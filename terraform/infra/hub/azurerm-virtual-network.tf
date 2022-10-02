resource "azurerm_virtual_network" "hub" {
	name = "${local.name}-vnet"
	resource_group_name = azurerm_resource_group.hub.name
	location = azurerm_resource_group.hub.location
	address_space       = [var.address_space]
}

resource azurerm_subnet pe {
  name = "PrivateEndpointSubnet"
  resource_group_name =  azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes = [cidrsubnet(var.address_space, 8, 0)]
}

resource azurerm_subnet consul {
  name = "ConsulSubnet"
  resource_group_name =  azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes = [cidrsubnet(var.address_space, 8, 1)]
}

resource azurerm_subnet nomad {
  name = "NomadSubnet"
  resource_group_name =  azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes = [cidrsubnet(var.address_space, 8, 2)]
}

resource azurerm_subnet vault {
  name = "VaultSubnet"
  resource_group_name =  azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes = [cidrsubnet(var.address_space, 8, 3)]
	service_endpoints    = ["Microsoft.Storage"]
	private_endpoint_network_policies_enabled = true
}

resource azurerm_subnet pki {
  name = "PkiSubnet"
  resource_group_name =  azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes = [cidrsubnet(var.address_space, 8, 4)]
	service_endpoints    = ["Microsoft.Storage"]
	private_endpoint_network_policies_enabled = true
}

resource azurerm_subnet prometheus {
  name = "PrometheusSubnet"
  resource_group_name =  azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes = [cidrsubnet(var.address_space, 8, 5)]
}

resource "azurerm_subnet" "aca" {
  name = "AcaSubnet"
  resource_group_name = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes = [cidrsubnet(var.address_space, 7, 4)]
  private_endpoint_network_policies_enabled = false
}

resource "azurerm_subnet" "aks" {
  name = "AksSubnet"
  resource_group_name = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes = [cidrsubnet(var.address_space, 6, 3)]
}

resource azurerm_subnet jumpbox {
	name = "JumpboxSubnet"
	resource_group_name  = azurerm_resource_group.hub.name
	virtual_network_name = azurerm_virtual_network.hub.name
	address_prefixes     = [cidrsubnet(var.address_space, 8, 255)]
  
}
