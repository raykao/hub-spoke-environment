# resource "azurerm_public_ip" "aks1" {
#   name                = "appgw-aks1-pip"
#   resource_group_name = azurerm_resource_group.spoke.name
#   location            = azurerm_resource_group.spoke.location
# 	sku = "Standard"
#   allocation_method   = "Static"
#   domain_name_label   = "${local.prefix}-appgw-aks1"
# }

# resource "azurerm_application_gateway" "aks1" {
#   name                = "aks1-appgateway"
#   resource_group_name = azurerm_resource_group.spoke.name
#   location            = azurerm_resource_group.spoke.location

#   sku {
#     name     = "WAF_v2"
#     tier     = "WAF_v2"
#     capacity = 2
#   }

#   frontend_port {
#     name = "http"
#     port = 80
#   }

#   frontend_ip_configuration {
#     name                 = "frontendIpConfiguration"
#     public_ip_address_id = azurerm_public_ip.aks1.id
#   }

# 	gateway_ip_configuration {
# 		name = "gateway-ip-configuration"
# 		subnet_id = azurerm_subnet.appgw-aks1.id
# 	}

#   backend_address_pool {
#     name = "aks1-cluster-bepool"
# 		ip_addresses = [cidrhost(azurerm_subnet.aks-ilb.address_prefixes[0], 4)]
#   }

#   backend_http_settings {
#     name                  = "http"
#     cookie_based_affinity = "Disabled"
#     path                  = "/"
#     port                  = 80
#     protocol              = "Http"
#     request_timeout       = 60
#     probe_name            = "basic-custom-probe"
#   }

#   http_listener {
#     name                           = "httpListener"
#     frontend_ip_configuration_name = "frontendIpConfiguration"
#     frontend_port_name             = "http"
#     protocol                       = "Http"
#   }

#   request_routing_rule {
#     name                       = "requestRoutingRule1"
#     rule_type                  = "Basic"
#     http_listener_name         = "httpListener"
#     backend_address_pool_name  = "aks1-cluster-bepool"
#     backend_http_settings_name = "http"
#   }

#   probe {
#     host = "10.1.4.4"
#     name = "basic-custom-probe"
#     port = "80"
#     path = "/healthz"
#     protocol = "Http"
#     interval = 30
#     timeout = 30
#     unhealthy_threshold = 3
#   }
# }