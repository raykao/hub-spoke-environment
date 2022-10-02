resource "azapi_resource" "aca-env" {
  type          = "Microsoft.App/managedEnvironments@2022-06-01-preview"
  parent_id     = var.resource_group.id
  location      = var.resource_group.location
  name          = "${local.name}"
  
  # Likely will need a property like this for setting UDR on ACA
  # Not supported as of Oct 2022
  #
  # sku = {
  #   name = "Premium"
  # }

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
            dockerBridgeCidr = var.dockerBridgeCidr
            platformReservedCidr = var.platformReservedCidr
            platformReservedDnsIP = var.platformReservedDnsIP
            # outboundSettings = {
            #   # Default is LoadBalancing
            #   # outBoundType = "UserDefinedRouting"
            # }
        }
    }
  })
}