# resource "azapi_resource" "aca-app" {
#   for_each  = { for ca in var.container_apps: ca.name => ca}
#   type      = "Microsoft.App/containerApps@2022-03-01"
#   parent_id = var.resource_group.id
#   location  = var.resource_group.location
#   name      = each.value.name
  
#   body = jsonencode({
#     properties: {
#       managedEnvironmentId = azapi_resource.aca-env.id
#       configuration = {
#         ingress = {
#           external = each.value.ingress_enabled
#           targetPort = each.value.ingress_enabled?each.value.containerPort: null
#         }
#       }
#       template = {
#         containers = [
#           {
#             name = each.value.name
#             image = "${each.value.image}:${each.value.tag}"
#             resources = {
#               cpu = each.value.cpu_requests
#               memory = each.value.mem_requests
#             }
#           }         
#         ]
#         scale = {
#           minReplicas = each.value.min_replicas
#           maxReplicas = each.value.max_replicas
#         }
#       }
#     }
#   })
# }