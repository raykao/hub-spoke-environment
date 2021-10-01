# resource "azurerm_public_ip" "aks1" {
#   name                = "appgw-aks1-pip"
#   resource_group_name = azurerm_resource_group.spoke1.name
#   location            = azurerm_resource_group.spoke1.location
# 	sku = "Standard"
#   allocation_method   = "Static"
# }

# # #&nbsp;since these variables are re-used - a locals block makes this more maintainable
# # locals {
# #   backend_address_pool_name      = "${azurerm_virtual_network.aks1.name}-beap"
# #   frontend_port_name             = "${azurerm_virtual_network.aks1.name}-feport"
# #   frontend_ip_configuration_name = "${azurerm_virtual_network.aks1.name}-feip"
# #   http_setting_name              = "${azurerm_virtual_network.aks1.name}-be-htst"
# #   listener_name                  = "${azurerm_virtual_network.aks1.name}-httplstn"
# #   request_routing_rule_name      = "${azurerm_virtual_network.aks1.name}-rqrt"
# #   redirect_configuration_name    = "${azurerm_virtual_network.aks1.name}-rdrcfg"
# # }

# resource "azurerm_application_gateway" "aks1" {
#   name                = "aks1-appgateway"
#   resource_group_name = azurerm_resource_group.spoke1.name
#   location            = azurerm_resource_group.spoke1.location

#   sku {
#     name     = "Standard_Small"
#     tier     = "Standard"
#     capacity = 2
#   }

#   gateway_ip_configuration {
#     name      = "my-gateway-ip-configuration"
#     subnet_id = azurerm_subnet.AppGwAks1.id
#   }

#   frontend_port {
#     name = "http"
#     port = 80
#   }

#   frontend_ip_configuration {
#     name                 = "frontendIpConfiguration"
#     public_ip_address_id = azurerm_public_ip.aks1.id
#   }

#   backend_address_pool {
#     name = local.backend_address_pool_name
#   }

#   backend_http_settings {
#     name                  = local.http_setting_name
#     cookie_based_affinity = "Disabled"
#     path                  = "/path1/"
#     port                  = 80
#     protocol              = "Http"
#     request_timeout       = 60
#   }

#   http_listener {
#     name                           = local.listener_name
#     frontend_ip_configuration_name = local.frontend_ip_configuration_name
#     frontend_port_name             = local.frontend_port_name
#     protocol                       = "Http"
#   }

#   request_routing_rule {
#     name                       = local.request_routing_rule_name
#     rule_type                  = "Basic"
#     http_listener_name         = local.listener_name
#     backend_address_pool_name  = local.backend_address_pool_name
#     backend_http_settings_name = local.http_setting_name
#   }
# }