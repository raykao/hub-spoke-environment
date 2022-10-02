module "aca" {	
	source = "../../modules/azure-container-apps"
	prefix = local.prefix
	resource_group = azurerm_resource_group.hub
	subnet_id = azurerm_subnet.aca.id
    subnet_prefix = azurerm_subnet.aca.address_prefixes[0]
}