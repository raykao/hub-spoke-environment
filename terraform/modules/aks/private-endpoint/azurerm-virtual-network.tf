resource "azurerm_resource_group" "default" {
  name = "${prefix}${name}-aks-pe-rg"
  location = var.location

}

resource "azurerm_virtual_network" "default" {
 name = "${local.name}-aks-pe-vnet"
 resource_group_name = azurerm_resource_group.default.name
 location = azurerm_resource_group.default.location
 address_space = [var.vnet_cidr]
}

resource "azurerm_subnet" "private_link_service" {
  name = "PrivateLinkServiceSubnet"
  resource_group_name = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes = [cidrsubnet(var.vnet_cidr, 8, 0)] # uses the first /24 cidr
}


resource "azurerm_subnet" "pls_lb" {
  name = "PlsLoadBalancerSubnet"
  resource_group_name = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes = [cidrsubnet(var.vnet_cidr, 8, 1)] # uses the second /24 cidr
}

resource "azurerm_subnet" "aks_lb" {
  name = "AksLoadBalancerSubnet"
  resource_group_name = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes = [cidrsubnet(var.vnet_cidr, 8, 2)] # uses the third /24 cidr
}

resource "azurerm_subnet" "aks" {
  name = "AksSubnet"
  resource_group_name = azurerm_resource_group.default.name
  virtual_network_name = azurerm_resource_group.default.name
  address_prefixes = [cidrsubnet(var.vnet_cidr, 6, 1)] # uses the second /22 cidr
}