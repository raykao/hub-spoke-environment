
resource "azurerm_traffic_manager_profile" "global" {
	provider = azurerm.sub1
  name                   = "${local.prefix}-hub-prod"
  resource_group_name    = azurerm_resource_group.hub.name
  traffic_routing_method = "Performance"

  dns_config {
    relative_name = "${local.prefix}-hub-prod"
    ttl           = 60
  }

  monitor_config {
    protocol                     = "http"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }
}