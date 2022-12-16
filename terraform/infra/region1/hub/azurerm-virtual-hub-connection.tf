resource "azurerm_virtual_hub_connection" "hub" {
 	name                      = "${local.prefix}-vhub"
  	virtual_hub_id            = var.vwan_hub_id
  	remote_virtual_network_id = azurerm_virtual_network.hub.id
	internet_security_enabled = true
}