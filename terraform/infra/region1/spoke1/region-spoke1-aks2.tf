resource "azurerm_user_assigned_identity" "aks2" {
  name                = "${local.prefix}-aks2-identity"
  resource_group_name = azurerm_resource_group.spoke1.name
  location            = azurerm_resource_group.spoke1.location
}

resource "azurerm_role_assignment" "aks2-dns" {
  scope                = azurerm_private_dns_zone.aks.id
#   scope = azurerm_resource_group.spoke1.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks2.principal_id
}

resource "azurerm_role_assignment" "aks2-network-contrib" {  	
	scope                = azurerm_virtual_network.spoke1.id
	role_definition_name = "Network Contributor"
	principal_id         = azurerm_user_assigned_identity.aks2.principal_id
}

# resource "azurerm_role_assignment" "aks-custom-role" {  	
# 	scope                = azurerm_resource_group.spoke1.id
# 	role_definition_name = "${local.prefix}-aks-custom-role"
# 	principal_id         = azurerm_user_assigned_identity.aks2.principal_id
# }


## Used because the custom role is not available
resource "azurerm_role_assignment" "aks2-contributor" {  	
	scope                = azurerm_resource_group.spoke1.id
	role_definition_name = "Contributor"
	principal_id         = azurerm_user_assigned_identity.aks2.principal_id
}

resource "time_sleep" "aks2_role_assignments" {
  depends_on = [
        azurerm_role_assignment.aks2-dns,
        azurerm_role_assignment.aks2-network-contrib,
		azurerm_role_assignment.aks2-contributor,
	]

  create_duration = "30s"
}


module aks2 {
	depends_on = [
	  time_sleep.aks2_role_assignments
	]
	
	source = "../../modules/aks/private"

	prefix = "${local.prefix}"
	suffix = "2"
	resource_group = azurerm_resource_group.spoke1
	subnet_id = azurerm_subnet.aks2.id
	private_dns_zone_id = azurerm_private_dns_zone.aks.id
	user_msi_id =  azurerm_user_assigned_identity.aks2.id
	admin_group_object_ids = var.admin_groups.aks
}