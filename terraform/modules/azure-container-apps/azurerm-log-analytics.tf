resource "azurerm_log_analytics_workspace" "aca-law" {
    depends_on = [
      azurerm_network_security_group.aca
    ]
    name                = "${var.prefix}-${var.name}-aca-law"
    resource_group_name =var.resource_group.name
    location            =var.resource_group.location
    sku                 = "PerGB2018"
    retention_in_days   = 90
}
