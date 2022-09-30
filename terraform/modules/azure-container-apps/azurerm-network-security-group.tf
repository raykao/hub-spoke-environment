
resource "azurerm_network_security_group" "aca" {
  name = "${var.prefix}-${var.name}-aca-nsg"
  resource_group_name = var.resource_group.name
  location = var.resource_group.location
}

resource "azurerm_network_security_rule" "subnet" {
  name                        = "AllowSubnet"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Any"
  source_address_prefix       = var.subnet.address_prefixes[0]
  source_port_range           = "*"
  destination_port_range      = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group.name
  network_security_group_name = azurerm_network_security_group.aca.name
}

resource "azurerm_network_security_rule" "loadBalancer" {
  name                        = "AllowAzLoadBalancer"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Any"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group.name
  network_security_group_name = azurerm_network_security_group.aca.name
}

resource "azurerm_network_security_rule" "aksUdp" {
  name                        = "AllowAksSecureNodesUdp"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "UDP"
  destination_address_prefix  = "AzureCloud.${var.resource_group.location}"
  destination_port_range      = "1194"
  source_address_prefix       = "*"
  source_port_range           = "*"
  resource_group_name         = var.resource_group.name
  network_security_group_name = azurerm_network_security_group.aca.name
}

resource "azurerm_network_security_rule" "aksTcp" {
  name                        = "AllowAksSecureNodesTcp"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "TCP"
  destination_address_prefix  = "AzureCloud.${var.resource_group.location}"
  destination_port_range      = "9000"
  source_address_prefix       = "*"
  source_port_range           = "*"
  resource_group_name         = var.resource_group.name
  network_security_group_name = azurerm_network_security_group.aca.name
}

resource "azurerm_network_security_rule" "azMon" {
  name                        = "AllowAzureMonitor"
  priority                    = 120
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "TCP"
  destination_address_prefix  = "AzureMonitor"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  source_port_range           = "*"
  resource_group_name         = var.resource_group.name
  network_security_group_name = azurerm_network_security_group.aca.name
}

resource "azurerm_network_security_rule" "https" {
  name                        = "AllowHttpsOut"
  priority                    = 130
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "TCP"
  destination_address_prefix  = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  source_port_range           = "*"
  resource_group_name         = var.resource_group.name
  network_security_group_name = azurerm_network_security_group.aca.name
}

resource "azurerm_network_security_rule" "http" {
  name                        = "AllowHttpOut"
  priority                    = 135
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "TCP"
  destination_address_prefix  = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  source_port_range           = "*"
  resource_group_name         = var.resource_group.name
  network_security_group_name = azurerm_network_security_group.aca.name
}

resource "azurerm_network_security_rule" "ntp" {
  name                        = "AllowNtpOut"
  priority                    = 140
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "UDP"
  destination_address_prefix  = "*"
  destination_port_range      = "123"
  source_address_prefix       = "*"
  source_port_range           = "*"
  resource_group_name         = var.resource_group.name
  network_security_group_name = azurerm_network_security_group.aca.name
}

resource "azurerm_network_security_rule" "acaControlPlane1" {
  name                        = "AllowControlPlane5671"
  priority                    = 140
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "TCP"
  destination_address_prefix  = "*"
  destination_port_range      = "5671"
  source_address_prefix       = "*"
  source_port_range           = "*"
  resource_group_name         = var.resource_group.name
  network_security_group_name = azurerm_network_security_group.aca.name
}

resource "azurerm_network_security_rule" "acaControlPlane2" {
  name                        = "AllowControlPlane5672"
  priority                    = 150
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "TCP"
  destination_address_prefix  = "*"
  destination_port_range      = "5672"
  source_address_prefix       = "*"
  source_port_range           = "*"
  resource_group_name         = var.resource_group.name
  network_security_group_name = azurerm_network_security_group.aca.name
}

resource "azurerm_network_security_rule" "acaControlPlane2" {
  name                        = "AllowControlPlane5672"
  priority                    = 160
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "TCP"
  destination_address_prefix  = var.subnet.address_prefixes[0]
  destination_port_range      = "*"
  source_address_prefix       = "*"
  source_port_range           = "*"
  resource_group_name         = var.resource_group.name
  network_security_group_name = azurerm_network_security_group.aca.name
}

resource "azurerm_subnet_network_security_group_association" "asa" {
  subnet_id = var.subnet.id
  network_security_group_id = azurerm_network_security_group.aca.id
}