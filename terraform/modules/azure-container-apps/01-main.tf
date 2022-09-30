terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.23.0"
    }
    azapi = {
      source = "Azure/azapi"
      version = "~> 1.0.0"
    }
  }
}

resource "azurerm_log_analytics_workspace" "aca-law" {
  name                = "${var.prefix}-aca-law"
  resource_group_name =var.resource_group.name
  location            =var.resource_group.location
  sku                 = "PerGB2018"
  retention_in_days   = 90
}

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
            infrastructureSubnetId = var.infrastructureSubnetId
            runtimeSubnetId = var.runtimeSubnetId
        }
    }
  })
}

resource "azapi_resource" "aca" {
  for_each  = { for ca in var.container_apps: ca.name => ca}
  type      = "Microsoft.App/containerApps@2022-03-01"
  parent_id = var.resource_group.id
  location  = var.resource_group.location
  name      = each.value.name
  
  body = jsonencode({
    properties: {
      managedEnvironmentId = azapi_resource.aca-env.id
      configuration = {
        ingress = {
          external = each.value.ingress_enabled
          targetPort = each.value.ingress_enabled?each.value.containerPort: null
        }
      }
      template = {
        containers = [
          {
            name = each.value.name
            image = "${each.value.image}:${each.value.tag}"
            resources = {
              cpu = each.value.cpu_requests
              memory = each.value.mem_requests
            }
          }         
        ]
        scale = {
          minReplicas = each.value.min_replicas
          maxReplicas = each.value.max_replicas
        }
      }
    }
  })
}