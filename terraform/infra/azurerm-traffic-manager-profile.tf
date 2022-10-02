# resource "azurerm_traffic_manager_profile" "global" {
#   name                   = "${local.prefix}-global-prod"
#   resource_group_name    = azurerm_resource_group.global.name
#   traffic_routing_method = "Performance"

#   dns_config {
#     relative_name = "${local.prefix}-global-prod"
#     ttl           = 60
#   }

#   monitor_config {
#     protocol                     = "HTTP"
#     port                         = 80
#     path                         = "/"
#     interval_in_seconds          = 30
#     timeout_in_seconds           = 9
#     tolerated_number_of_failures = 3
#   }
# }