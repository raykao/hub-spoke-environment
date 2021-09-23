module hub {
	source = "./hub"
	
	providers = {
		azurerm = azurerm.sub1
	}
	prefix = local.prefix
	location = "canadacentral"
	contributor_msi = module.global.contributor_msi
	admin_username = local.admin_username
	address_space = cidrsubnet(var.global_address_space, 8, 0)
	domain = var.domain
}


# resource "azurerm_virtual_network_peering" "hubtospoke1" {
	
# 	name                      = "hubtospoke1"
# 	resource_group_name       = azurerm_resource_group.hub.name
# 	virtual_network_name      = azurerm_virtual_network.hub.name
# 	remote_virtual_network_id = azurerm_virtual_network.spoke1.id
# }

# resource "azurerm_virtual_network_peering" "hubtospoke2" {
	
# 	name                      = "hubtospoke2"
# 	resource_group_name       = azurerm_resource_group.hub.name
# 	virtual_network_name      = azurerm_virtual_network.hub.name
# 	remote_virtual_network_id = azurerm_virtual_network.spoke2.id
# }

# resource "azurerm_virtual_network_peering" "hubtospoke3" {
	
# 	name                      = "hubtospoke3"
# 	resource_group_name       = azurerm_resource_group.hub.name
# 	virtual_network_name      = azurerm_virtual_network.hub.name
# 	remote_virtual_network_id = azurerm_virtual_network.spoke3.id
# }