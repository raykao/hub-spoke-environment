resource "azurerm_resource_group" "spoke3" {
	provider = azurerm.sub2
  	name = "${local.prefix}spoke3-rg"
  	location = var.location3
}

resource "azurerm_role_assignment" "spoke3" {
  	
	scope                = azurerm_resource_group.spoke3.id
	role_definition_name = "Contributor"
	principal_id         = azurerm_user_assigned_identity.jumpbox.principal_id
}