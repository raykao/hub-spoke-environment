output "private_ip_address" {
  value = azurerm_network_interface.jumpbox.ip_configuration[0].private_ip_address
}
