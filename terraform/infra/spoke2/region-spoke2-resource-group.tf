resource "azurerm_resource_group" "spoke2" {
	name = "${local.prefix}"
	location = var.location
}

resource "azurerm_role_assignment" "spoke2" {
	scope                = azurerm_resource_group.spoke2.id
	role_definition_name = "Contributor"
	principal_id         = var.contributor_msi.principal_id
}