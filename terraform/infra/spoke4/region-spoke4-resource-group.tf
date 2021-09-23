resource "azurerm_resource_group" "spoke4" {
	
  	name = "${local.prefix}spoke4-rg"
  	location = var.location3
}

resource "azurerm_role_assignment" "spoke4" {
  	
	scope                = azurerm_resource_group.spoke4.id
	role_definition_name = "Contributor"
	principal_id         = azurerm_user_assigned_identity.jumpbox.principal_id
}