resource "azurerm_resource_group" "spoke" {
  	name = "${local.prefix}"
  	location = var.location
}

# resource "azurerm_role_assignment" "spoke" {  	
# 	scope                = azurerm_resource_group.spoke.id
# 	role_definition_name = "Contributor"
# 	principal_id         = var.contributor_msi.principal_id
# }