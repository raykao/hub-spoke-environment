module "dns" {
  depends_on = [
    # azurerm_virtual_network_gateway.default
  ]
  source = "../../modules/bind9"
  prefix = local.prefix
  vnet_address_spaces = [var.global_address_space]
  subnet_id = azurerm_subnet.dns.id
  resource_group = azurerm_resource_group.hub
  admin_username = var.admin_username
  ssh_key = var.ssh_key
  admin_subnet_prefix = azurerm_subnet.jumpbox.address_prefixes[0]
}