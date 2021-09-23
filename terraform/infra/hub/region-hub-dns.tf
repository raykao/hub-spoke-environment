resource "azurerm_private_dns_zone" "hub" {
	name                = "hub.${var.domain}"
	resource_group_name = azurerm_resource_group.hub.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub" {
	name                  = "hub-priv-dns-link"
	resource_group_name   = azurerm_resource_group.hub.name
	private_dns_zone_name = azurerm_private_dns_zone.hub.name
	virtual_network_id    = azurerm_virtual_network.hub.id
	registration_enabled  = true
}

# resource "azurerm_private_dns_zone_virtual_network_link" "spoke1" {
	

# 	name                  = "spoke1-priv-dns-link"
# 	resource_group_name   = azurerm_resource_group.hub.name
# 	private_dns_zone_name = azurerm_private_dns_zone.hub.name
# 	virtual_network_id    = azurerm_virtual_network.spoke1.id
# 	registration_enabled  = true
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "spoke2" {
	

# 	name                  = "spoke2-priv-dns-link"
# 	resource_group_name   = azurerm_resource_group.hub.name
# 	private_dns_zone_name = azurerm_private_dns_zone.hub.name
# 	virtual_network_id    = azurerm_virtual_network.spoke2.id
# 	registration_enabled  = true
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "spoke3" {
	

# 	name                  = "spoke3-priv-dns-link"
# 	resource_group_name   = azurerm_resource_group.hub.name
# 	private_dns_zone_name = azurerm_private_dns_zone.hub.name
# 	virtual_network_id    = azurerm_virtual_network.spoke3.id
# 	registration_enabled  = true
# }

# resource "azurerm_dns_zone" "prod" {
	
# 	name                = "prod.${var.domain}"
# 	resource_group_name = azurerm_resource_group.hub.name
# }

# resource "azurerm_dns_zone" "dev" {
	
# 	name                = "dev.${var.domain}"
# 	resource_group_name = azurerm_resource_group.hub.name
# }
