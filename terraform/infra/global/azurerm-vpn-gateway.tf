resource "azurerm_vpn_gateway" "canadacentral" {
  name                = "canadacentral-vpngw"
  location            = "canadacentral"
  resource_group_name = azurerm_resource_group.global.name
  virtual_hub_id      = azurerm_virtual_hub.all["canadacentral"].id
}