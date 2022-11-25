resource "azurerm_lb" "pls-firsthop" {
  name                = "pls-firsthop-lb"
  sku                 = "Standard"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  frontend_ip_configuration {
    name                       = "primary"
    subnet_id = azurerm_subnet.pls_lb.id
  }
}

resource "azurerm_lb_backend_address_pool" "aks" {
  loadbalancer_id = azurerm_lb.pls-firsthop.id
  name            = "AksBackEndAddressPool"
}

resource "azurerm_lb_backend_address_pool_address" "aks_lb_1" {
  name                    = "aks_lb_1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.aks.id
  virtual_network_id      = azurerm_virtual_network.default.id
  ip_address              = cidrhost(azurerm_subnet.aks_lb.address_prefixes[0], 5) # points to the first IP in the AksLoadBalancerSubnet ".5" 
}

resource "azurerm_lb_rule" "aks_lb_1_http" {
  name                           = "http"
  resource_group_name            = azurerm_resource_group.default.name
  loadbalancer_id                = azurerm_lb.pls-firsthop.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "primary"
  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.aks.id
  ]
}

resource "azurerm_lb_rule" "aks_lb_1_https" {
  name                           = "https"
  resource_group_name            = azurerm_resource_group.default.name
  loadbalancer_id                = azurerm_lb.pls-firsthop.id
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "primary"
  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.aks.id
  ]
}

resource "azurerm_private_link_service" "default" {
  name                = "aks-privatelink"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  auto_approval_subscription_ids              = var.auto_approval_subscription_ids
  visibility_subscription_ids                 = var.visibility_subscription_ids
  load_balancer_frontend_ip_configuration_ids = [azurerm_lb.default.frontend_ip_configuration.0.id]

  nat_ip_configuration {
    name                       = "primary"
    private_ip_address         = cidrhost(azurerm_subnet.private_link_service.address_prefixes[0], 5)
    private_ip_address_version = "IPv4"
    subnet_id                  = azurerm_subnet.private_link_service.id
    primary                    = true
  }
}