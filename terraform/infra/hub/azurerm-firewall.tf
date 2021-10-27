resource "azurerm_public_ip" "firewall" {
	
	name                = "${local.prefix}-hub-fw-pip"
	location            = azurerm_resource_group.hub.location
	resource_group_name = azurerm_resource_group.hub.name
	allocation_method   = "Static"
	sku                 = "Standard"
  availability_zone   = "No-Zone"
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

resource "azurerm_firewall_application_rule_collection" "globalVnetAllowRules" {
  name                = "globalVnetAllowRules"
  azure_firewall_name = azurerm_firewall.hub.name
  resource_group_name = azurerm_resource_group.hub.name
  priority            = 100
  action              = "Allow"

  rule {
    name = "ubuntuUpdates"

    source_addresses = [
      var.global_address_space
    ]

    target_fqdns  = [
			"*.ubuntu.com",
			"*.archive.ubuntu.com",
      "*.azure.archive.ubuntu.com",
			"apt.releases.hashicorp.com",
      "*.microsoft.com",
      "aka.ms",
      "management.azure.com"
    ]

    protocol {
      port = "443"
			type = "Https"
		}
  }

	rule {
    name = "ubuntuHttpUpdates"

    source_addresses = [
      var.global_address_space
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


resource "azurerm_firewall_application_rule_collection" "hashi" {
  name                = "hashiUpdateRules"
  azure_firewall_name = azurerm_firewall.hub.name
  resource_group_name = azurerm_resource_group.hub.name
  priority            = 500
  action              = "Allow"

  rule {
    name = "updatesRequired"

    source_addresses = [
      azurerm_subnet.consul.address_prefixes[0],
      azurerm_subnet.vault.address_prefixes[0],
      azurerm_subnet.nomad.address_prefixes[0]
    ]

    target_fqdns  = [
			"*.ubuntu.com",
			"*.archive.ubuntu.com",
      "*.azure.archive.ubuntu.com",
			"apt.releases.hashicorp.com",
      "*.hashicorp.com"
    ]

    protocol {
      port = "80"
			type = "Http"
		}

    protocol {
      port = "443"
			type = "Https"
		}
  }

  rule {
    name = "vaultRequired"

    source_addresses = [
      azurerm_subnet.vault.address_prefixes[0],
    ]

    target_fqdns  = [
			"*.postgresql.org",
      "*.hashicorp.com"
    ]

    protocol {
      port = "80"
			type = "Http"
		}

    protocol {
      port = "443"
			type = "Https"
		}
  }
}


resource "azurerm_firewall_application_rule_collection" "pki" {
  name                = "pkiUpdateRules"
  azure_firewall_name = azurerm_firewall.hub.name
  resource_group_name = azurerm_resource_group.hub.name
  priority            = 600
  action              = "Allow"

  rule {
    name = "updates"

    source_addresses = [
      azurerm_subnet.pki.address_prefixes[0]
    ]

    target_fqdns  = [
			"dl.step.sm",
      "github.com",
      "github-releases.githubusercontent.com"
    ]

    protocol {
      port = "443"
			type = "Https"
		}
  }
}
