resource "azurerm_resource_group" "spoke1" {
  	name = "${local.prefix}spoke1"
  	location = var.location
}

resource "azurerm_role_assignment" "spoke1" {  	
	scope                = azurerm_resource_group.spoke1.id
	role_definition_name = "Contributor"
	principal_id         = var.contributor_msi.principal_id
}