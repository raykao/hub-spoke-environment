output "subnet_id" {
  value = var.subnet.id
}

output "nsg_id" {
  value = azurerm_network_security_group.aca.id
}

output "managedEnvironmentId" {
  value = jsondecode(azapi_resource.aca-env.output).properties.id
}

output "id" {
  value = jsondecode(azapi_resource.aca-env.output).properties.id
}