resource "azurerm_private_dns_zone" "priv-dns-spoke" {
	provider = azurerm.sub2
	name                = "privatelink.file.core.windows.net"
	resource_group_name = azurerm_resource_group.spoke2.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage-hub" {
	provider = azurerm.sub2
	name                  = "priv-link-hub"
	resource_group_name   = azurerm_resource_group.spoke2.name
	private_dns_zone_name = azurerm_private_dns_zone.priv-dns-spoke.name
	virtual_network_id    = azurerm_virtual_network.hub.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage-spoke1" {
	provider = azurerm.sub2
	name                  = "priv-link-spoke1"
	resource_group_name   = azurerm_resource_group.spoke2.name
	private_dns_zone_name = azurerm_private_dns_zone.priv-dns-spoke.name
	virtual_network_id    = azurerm_virtual_network.spoke1.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage-spoke2" {
	provider = azurerm.sub2
	name                  = "priv-link-spoke2"
	resource_group_name   = azurerm_resource_group.spoke2.name
	private_dns_zone_name = azurerm_private_dns_zone.priv-dns-spoke.name
	virtual_network_id    = azurerm_virtual_network.spoke2.id
}

resource "azurerm_private_endpoint" "storage-spoke2" {
	provider = azurerm.sub2
	name = "pe-storage-spoke2"
	location = azurerm_resource_group.spoke2.location
	resource_group_name = azurerm_resource_group.spoke2.name
	subnet_id = azurerm_subnet.spoke2-pe.id

  private_service_connection {
	name = "storage-privateserviceconnection"
	is_manual_connection = false
	private_connection_resource_id = azurerm_storage_account.spoke2.id
	subresource_names = ["file"]
  }

   private_dns_zone_group {
    name                  = "storage-dns-group"
    private_dns_zone_ids  = [ azurerm_private_dns_zone.priv-dns-spoke.id ]
  }
}

resource "azurerm_dns_zone" "spoke2" {
	provider = azurerm.sub2
	name                = "spoke2.${var.domain}"
	resource_group_name = azurerm_resource_group.spoke2.name
}