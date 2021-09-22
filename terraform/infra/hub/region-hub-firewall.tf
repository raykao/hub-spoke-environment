resource "azurerm_public_ip" "firewall" {
	provider = azurerm.sub1
	name                = "${local.prefix}-hub-fw-pip"
	location            = azurerm_resource_group.hub.location
	resource_group_name = azurerm_resource_group.hub.name
	allocation_method   = "Static"
	sku                 = "Standard"
}

resource "azurerm_firewall" "hub" {
	provider = azurerm.sub1
	name                = "${local.prefix}-hub-fw"
	location            = azurerm_resource_group.hub.location
	resource_group_name = azurerm_resource_group.hub.name

	ip_configuration {
		name                 = "configuration"
		subnet_id            = azurerm_subnet.firewall.id
		public_ip_address_id = azurerm_public_ip.firewall.id
	}
}