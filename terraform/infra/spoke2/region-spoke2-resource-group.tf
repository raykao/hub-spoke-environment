resource "azurerm_resource_group" "spoke2" {
	provider = azurerm.sub2
  	name = "${local.prefix}spoke2-rg"
  	location = var.location2
}

resource "azurerm_role_assignment" "spoke2" {
  	
	scope                = azurerm_resource_group.spoke2.id
	role_definition_name = "Contributor"
	principal_id         = azurerm_user_assigned_identity.jumpbox.principal_id
}