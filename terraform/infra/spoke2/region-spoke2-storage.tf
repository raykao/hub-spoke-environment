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