resource "azurerm_log_analytics_workspace" "aks" {
  name                = "${local.cluster_name}-logA-ws"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}