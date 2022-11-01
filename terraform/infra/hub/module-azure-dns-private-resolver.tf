
resource "azurerm_private_dns_resolver" "hub" {
  name                = "${local.name}-priv-dns-resolver"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  virtual_network_id  = azurerm_virtual_network.hub.id
}


resource "azurerm_private_dns_resolver_inbound_endpoint" "hub" {
  name                    = "dns-inbound-endpoint"
  private_dns_resolver_id = azurerm_private_dns_resolver.hub.id
  location                = azurerm_private_dns_resolver.hub.location
  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = azurerm_subnet.dns_resolver_in.id
  }
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "hub" {
  name                    = "dns-outbound-endpoint"
  private_dns_resolver_id = azurerm_private_dns_resolver.hub.id
  location                = azurerm_private_dns_resolver.hub.location
  subnet_id               = azurerm_subnet.dns_resolver_out.id
 }