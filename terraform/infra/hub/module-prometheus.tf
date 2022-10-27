## Custom Roles Exceeded in AAD Tenant Directory
# 
# resource "azurerm_role_definition" "aks" {
#   name        = "${local.prefix}-aks-custom-role"
#   scope       = azurerm_resource_group.spoke1.id
#   description = "This is a custom role created via Terraform"

#   permissions {
# 	#   https://docs.microsoft.com/en-us/azure/aks/concepts-identity
#     actions     = [
# 		"Microsoft.ContainerService/managedClusters/*",
		
# 		"Microsoft.Network/publicIPAddresses/read",
# 		"Microsoft.Network/publicIPAddresses/write",
# 		"Microsoft.Network/publicIPAddresses/delete",
# 		"Microsoft.Network/publicIPAddresses/join/action",

# 		"Microsoft.Network/loadBalancers/read",
# 		"Microsoft.Network/loadBalancers/write",
# 		"Microsoft.Network/loadBalancers/delete",

# 		"Microsoft.Network/networkSecurityGroups/read",
# 		"Microsoft.Network/networkSecurityGroups/write",

# 		"Microsoft.Compute/disks/delete",
# 		"Microsoft.Compute/disks/read",
# 		"Microsoft.Compute/disks/write",
# 		"Microsoft.Compute/locations/DiskOperations/read",

# 		"Microsoft.Storage/storageAccounts/delete",
# 		"Microsoft.Storage/storageAccounts/listKeys/action",
# 		"Microsoft.Storage/storageAccounts/read",
# 		"Microsoft.Storage/storageAccounts/write",
# 		"Microsoft.Storage/operations/read",

# 		"Microsoft.Network/routeTables/read",
# 		"Microsoft.Network/routeTables/routes/delete",
# 		"Microsoft.Network/routeTables/routes/read",
# 		"Microsoft.Network/routeTables/routes/write",
# 		"Microsoft.Network/routeTables/write",

# 		"Microsoft.Compute/virtualMachines/read",

# 		"Microsoft.Compute/virtualMachines/write",

# 		"Microsoft.Compute/virtualMachineScaleSets/read",
# 		"Microsoft.Compute/virtualMachineScaleSets/virtualMachines/read",
# 		"Microsoft.Compute/virtualMachineScaleSets/virtualmachines/instanceView/read",

# 		"Microsoft.Network/networkInterfaces/write",

# 		"Microsoft.Compute/virtualMachineScaleSets/write",

# 		"Microsoft.Compute/virtualMachineScaleSets/virtualmachines/write",

# 		"Microsoft.Network/networkInterfaces/read",

# 		"Microsoft.Compute/virtualMachineScaleSets/virtualMachines/networkInterfaces/read",

# 		"Microsoft.Compute/virtualMachineScaleSets/virtualMachines/networkInterfaces/ipconfigurations/publicipaddresses/read",

# 		"Microsoft.Network/virtualNetworks/read",
# 		"Microsoft.Network/virtualNetworks/subnets/read",

# 		"Microsoft.Compute/snapshots/delete",
# 		"Microsoft.Compute/snapshots/read",
# 		"Microsoft.Compute/snapshots/write",

# 		"Microsoft.Compute/locations/vmSizes/read",
# 		"Microsoft.Compute/locations/operations/read",

# 		# https://docs.microsoft.com/en-us/azure/aks/concepts-identity#additional-cluster-identity-permissions
# 		"Microsoft.Network/virtualNetworks/subnets/join/action",

# 		"Microsoft.Network/privatednszones/*"
# 	]
#   }
# }

# resource "azurerm_role_assignment" "aks-custom-role" {  	
# 	scope                = azurerm_resource_group.spoke1.id
# 	role_definition_name = "${local.prefix}-aks-custom-role"
# 	principal_id         = azurerm_user_assigned_identity.aks.principal_id
# }

resource "azurerm_user_assigned_identity" "prom-aks" {
  name                = "${local.prefix}-prom-aks-identity"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
}

resource "azurerm_role_assignment" "prom-aks-dns" {
  scope                = azurerm_private_dns_zone.prom-aks.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.prom-aks.principal_id
}

resource "azurerm_role_assignment" "prom-aks-network-contrib" {  	
	scope                = azurerm_virtual_network.hub.id
	role_definition_name = "Network Contributor"
	principal_id         = azurerm_user_assigned_identity.prom-aks.principal_id
}

## Used because the custom role is not available
resource "azurerm_role_assignment" "prom-aks-contributor" {  	
	scope                = azurerm_resource_group.hub.id
	role_definition_name = "Contributor"
	principal_id         = azurerm_user_assigned_identity.prom-aks.principal_id
}

# resource "time_sleep" "aks_role_assignments" {
#   depends_on = [
#         azurerm_role_assignment.aks-dns,
#         azurerm_role_assignment.aks-network-contrib,
# 		azurerm_role_assignment.aks-contributor,
# 	]

#   create_duration = "30s"
# }

module prom1 {
	# depends_on = [
	#   time_sleep.aks_role_assignments
	# ]
	
	source = "../../modules/prometheus"
	prefix = "${local.prefix}"
	suffix = "1"
	resource_group = azurerm_resource_group.hub
	subnet_id = azurerm_subnet.aks1.id
	private_dns_zone_id = azurerm_private_dns_zone.aks.id
	user_msi_id =  azurerm_user_assigned_identity.aks.id
	admin_group_object_ids = var.admin_groups.aks
}