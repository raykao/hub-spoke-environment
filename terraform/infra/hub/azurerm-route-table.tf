resource "azurerm_route_table" "default" {
  depends_on = [
    azurerm_virtual_network_gateway.default
  ]
  name                = "default-routetable"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  route {
    name                   = "hub"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.hub.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "consul" {
  subnet_id      = azurerm_subnet.consul.id
  route_table_id = azurerm_route_table.default.id
}

resource "azurerm_subnet_route_table_association" "vault" {
  subnet_id      = azurerm_subnet.vault.id
  route_table_id = azurerm_route_table.default.id
}

resource "azurerm_subnet_route_table_association" "nomad" {
  subnet_id      = azurerm_subnet.nomad.id
  route_table_id = azurerm_route_table.default.id
}

resource "azurerm_subnet_route_table_association" "dns" {
  subnet_id      = azurerm_subnet.dns.id
  route_table_id = azurerm_route_table.default.id
}

# resource "azurerm_subnet_route_table_association" "prometheus" {
#   subnet_id      = azurerm_subnet.prometheus.id
#   route_table_id = azurerm_route_table.default.id
# }