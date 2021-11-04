resource "azurerm_storage_account" "spoke2" {
  name                     = "${local.prefix}spoke2sa"
  resource_group_name      = azurerm_resource_group.spoke2.name
  location                 = azurerm_resource_group.spoke2.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "spoke2" {
  name                 = "${local.prefix}fs"
  storage_account_name = azurerm_storage_account.spoke2.name
  quota                = 5120
}

resource "azurerm_private_endpoint" "storage-spoke2" {
	name = "${local.prefix}-pe-storage-spoke2"
	location = azurerm_resource_group.spoke2.location
	resource_group_name = azurerm_resource_group.spoke2.name
	subnet_id = azurerm_subnet.spoke2-pe.id

  private_service_connection {
	name = "${local.prefix}storage-privateserviceconnection"
	is_manual_connection = false
	private_connection_resource_id = azurerm_storage_account.spoke2.id
	subresource_names = ["file"]
  }

   private_dns_zone_group {
    name                  = "storage-dns-group"
    private_dns_zone_ids  = [ azurerm_private_dns_zone.storage-priv-link.id ]
  }
}

resource "azurerm_storage_account_network_rules" "spoke2" {
  # resource_group_name  = azurerm_resource_group.spoke2.name
  # storage_account_name = azurerm_storage_account.spoke2.name
  storage_account_id = azurerm_storage_account.spoke2.id

  default_action             = "Deny"
  # virtual_network_subnet_ids = [azurerm_subnet.spoke2-pe.id]
  # bypass                     = ["Logging", "Metrics", "AzureServices"]

  private_link_access {
    endpoint_resource_id = azurerm_private_endpoint.storage-spoke2.id
  }
}