resource "azurerm_resource_group" "spoke3" {
  	name = "${local.prefix}"
  	location = var.location
}

resource "azurerm_role_assignment" "spoke3" {  	
	scope                = azurerm_resource_group.spoke3.id
	role_definition_name = "Contributor"
	principal_id         = var.contributor_msi.principal_id
}