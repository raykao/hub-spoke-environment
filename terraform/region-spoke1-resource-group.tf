resource "azurerm_resource_group" "spoke1" {
	provider = azurerm.sub1
  	name = "${local.prefix}spoke1-rg"
  	location = var.location1
}

resource "azurerm_role_assignment" "spoke1" {
  	provider = azurerm.sub1
	scope                = azurerm_resource_group.spoke1.id
	role_definition_name = "Contributor"
	principal_id         = azurerm_user_assigned_identity.jumpbox.principal_id
}