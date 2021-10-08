resource "azurerm_public_ip" "firewall" {
	
	name                = "${local.prefix}-hub-fw-pip"
	location            = azurerm_resource_group.hub.location
	resource_group_name = azurerm_resource_group.hub.name
	allocation_method   = "Static"
	sku                 = "Standard"
}

resource "azurerm_firewall" "hub" {
	
	name                = "${local.prefix}-hub-fw"
	location            = azurerm_resource_group.hub.location
	resource_group_name = azurerm_resource_group.hub.name

	ip_configuration {
		name                 = "configuration"
		subnet_id            = azurerm_subnet.firewall.id
		public_ip_address_id = azurerm_public_ip.firewall.id
	}
}


resource "azurerm_firewall_application_rule_collection" "consul" {
  name                = "consulRules"
  azure_firewall_name = azurerm_firewall.hub.name
  resource_group_name = azurerm_resource_group.hub.name
  priority            = 100
  action              = "Allow"

  rule {
    name = "ubuntuUpdates"

    source_addresses = [
      azurerm_subnet.consul.address_prefixes[0]
    ]

    target_fqdns  = [
			"*.ubuntu.com",
			"*.archive.ubuntu.com",
      "*.azure.archive.ubuntu.com",
			"apt.releases.hashicorp.com"
    ]

    protocol {
      port = "443"
			type = "Https"
		}
  }

	rule {
    name = "ubuntuHttpUpdates"

    source_addresses = [
      azurerm_subnet.consul.address_prefixes[0]
    ]

    target_fqdns  = [
			"*.ubuntu.com",
			"*.archive.ubuntu.com",
      "*.azure.archive.ubuntu.com",
			"apt.releases.hashicorp.com"
    ]

    protocol {
      port = "80"
			type = "Http"
		}
  }
}


resource "azurerm_route_table" "test" {
  name                = "test-routetable"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  route {
    name                   = "hub"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.hub.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "hub" {
  subnet_id      = azurerm_subnet.consul.id
  route_table_id = azurerm_route_table.test.id
}