
resource "azurerm_private_dns_resolver" "hub" {
  name                = "${local.prefix}-priv-dns-resolver"
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

 
resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "outbound" {
  name                                       = "outbound-ruleset"
  resource_group_name                        = azurerm_resource_group.hub.name
  location                                   = azurerm_resource_group.hub.location
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.hub.id]
  tags = {
    key = "value"
  }
}

resource "azurerm_private_dns_resolver_forwarding_rule" "example" {
  name                      = "example-rule"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.outbound.id
  domain_name               = var.onprem_domain
  enabled                   = true
  target_dns_servers {
    ip_address = var.onprem_dns_server
    port       = 53
  }
  metadata = {
    key = "value"
  }
}

resource "azurerm_private_dns_resolver_virtual_network_link" "hub-outbound" {
  name                                           = "hub-outbound-link"
  dns_forwarding_ruleset_id                      = azurerm_private_dns_resolver_dns_forwarding_ruleset.outbound.id
  virtual_network_id                             = azurerm_virtual_network.hub.id
}