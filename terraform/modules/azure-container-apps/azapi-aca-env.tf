resource "azapi_resource" "aca-env" {
  type          = "Microsoft.App/managedEnvironments@2022-03-01"
  parent_id     = var.resource_group.id
  location      = var.resource_group.location
  name          = "${var.prefix}"
  
  body = jsonencode({
    properties = {
        appLogsConfiguration = {
            destination = "log-analytics"
            logAnalyticsConfiguration = {
                customerId = azurerm_log_analytics_workspace.aca-law.workspace_id
                sharedKey = azurerm_log_analytics_workspace.aca-law.primary_shared_key
            }
        }
        vnetConfiguration = {
            internal = true
            infrastructureSubnetId = var.subnet_id
        }
    }
  })
}
