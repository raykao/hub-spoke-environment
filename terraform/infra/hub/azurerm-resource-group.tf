resource "azurerm_resource_group" "hub" {
  	name = "${local.prefix}"
  	location = var.location
}

# resource "azurerm_role_assignment" "hub" {  	
# 	scope                = azurerm_resource_group.hub.id
# 	role_definition_name = "Contributor"
# 	principal_id         = var.contributor_msi.principal_id
# }