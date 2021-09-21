resource "azurerm_resource_group" "spoke2" {
	provider = azurerm.sub2
  	name = "${local.prefix}spoke2-rg"
  	location = local.location
}

resource "azurerm_virtual_network" "spoke2" {
	provider = azurerm.sub2
	name = "${local.prefix}spoke2-vnet"
	resource_group_name = azurerm_resource_group.spoke2.name
	location = azurerm_resource_group.spoke2.location
	address_space       = [var.spoke2_address_space]
}

resource "azurerm_subnet" "spoke2-pe" {
	provider = azurerm.sub2
	name = "StoragePeSubnet"
	resource_group_name  = azurerm_resource_group.spoke2.name
	virtual_network_name = azurerm_virtual_network.spoke2.name
	address_prefixes     = [cidrsubnet(azurerm_virtual_network.spoke2.address_space[0], 8, 0)]
	enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_virtual_network_peering" "spoke2tohub" {
	provider = azurerm.sub2
	name                      = "spoke2tohub"
	resource_group_name       = azurerm_resource_group.spoke2.name
	virtual_network_name      = azurerm_virtual_network.spoke2.name
	remote_virtual_network_id = azurerm_virtual_network.hub.id
}

resource "azurerm_storage_account" "spoke2" {
  provider = azurerm.sub2
  name                     = "${local.prefix}spoke2sa"
  resource_group_name      = azurerm_resource_group.spoke2.name
  location                 = azurerm_resource_group.spoke2.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "spoke2" {
  provider = azurerm.sub2
  name                 = "${local.prefix}fs"
  storage_account_name = azurerm_storage_account.spoke2.name
  quota                = 5120
}

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