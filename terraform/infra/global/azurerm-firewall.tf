resource "azurerm_firewall" "hubs" {
	for_each = {
		for idx, region in var.virtual_hub_regions: region => idx
	}

	name                = "${local.prefix}-global-${each.key}-fw"
	location            = "${each.key}"
	resource_group_name = azurerm_resource_group.global.name

	sku_name = "AZFW_Hub"
	sku_tier = "Standard"

	firewall_policy_id = azurerm_firewall_policy.hubs["${each.key}"].id

	virtual_hub {
		virtual_hub_id = azurerm_virtual_hub.all["${each.key}"].id
		public_ip_count = 1
	}
}

resource "azurerm_firewall_policy" "hubs" {
  for_each = {
		for idx, region in var.virtual_hub_regions: region => idx
	}
  name                = "${each.key}FwPolicy"
  resource_group_name = azurerm_resource_group.global.name
  location            = "${each.key}"
}

resource "azurerm_firewall_policy_rule_collection_group" "hubs" {
  for_each = {
		for idx, region in var.virtual_hub_regions: region => idx
	}
	name               = "fwpolicy-${each.key}-rcg"
	firewall_policy_id = azurerm_firewall_policy.hubs["${each.key}"].id
  	priority           = 100

	application_rule_collection {
    name     = "ubuntuUpdates"
    priority = 100
    action   = "Allow"

    rule {
		name = "app_rule_collection1_rule1"
		
				protocols {
			type = "Http"
			port = 80
		}

		protocols {
			type = "Https"
			port = 443
		}
		
		source_addresses  = [
			"*"
		]

		destination_fqdns = [
			"*.ubuntu.com",
			"*.archive.ubuntu.com",
			"*.azure.archive.ubuntu.com",
			"apt.releases.hashicorp.com",
			"*.hashicorp.com",
			"*.microsoft.com",
			"*.opensuse.org",
			"aka.ms",
			"management.azure.com",
			"api.snapcraft.io"
		]
    }
  }
}

# resource "azurerm_firewall_policy_rule_collection_group" "global" {
# 	name               = "spoke1-fwpolicy-rcg"
#   firewall_policy_id = azurerm_firewall_policy.hubs["canadacentral"].id
#   priority           = 100

# 	network_rule_collection {
# 		name = "jumpbox-allow-all-outbound"
# 		priority = 400
# 		action = "Allow"

# 		rule {
# 			name = "all"
# 			protocols = ["Any"]
# 			source_addresses = ["10.1.255.0/24"]
# 			destination_ports = ["*"]
# 			destination_addresses = ["*"]
# 		} 
# 	}

# 	application_rule_collection {
#     name     = "ubuntuUpdates"
#     priority = 500
#     action   = "Allow"

#     rule {
#       name = "app_rule_collection1_rule1"
      
# 			protocols {
#         type = "Http"
#         port = 80
#       }

#       protocols {
#         type = "Https"
#         port = 443
#       }
      
# 			source_addresses  = [
# 				"10.1.0.0/16"
# 			]
      
# 			destination_fqdns = [
# 				"*.ubuntu.com",
# 				"*.archive.ubuntu.com",
# 				"*.azure.archive.ubuntu.com",
# 				"apt.releases.hashicorp.com",
# 				"*.microsoft.com",
# 				"aka.ms",
# 				"management.azure.com"
# 			]
#     }
#   }
# }


# resource "azurerm_firewall_policy_rule_collection_group" "jumpbox" {
# 	name               = "jumpbox-fwpolicy-rcg"
#   firewall_policy_id = azurerm_firewall_policy.hubs["canadacentral"].id
#   priority           = 510
  #     nat_rule_collection {
  #   name     = "jumpbox-ssh"
  #   priority = 300
  #   action   = "Dnat"
  #   rule {
  #     name                = "ssh"
  #     protocols           = ["TCP"]
  #     source_addresses    = ["*"]
  #     destination_address = azurerm_firewall.hubs["canadacentral"].virtual_hub[0].public_ip_addresses[0]
  #     destination_ports   = ["2022"]
  #     translated_address  = "10.1.255.4"
  #     translated_port     = "2022"
  #   }
  # }

	# nat_rule_collection {
  #   name     = "jumpbox-xrdp"
  #   priority = 301
  #   action   = "Dnat"
  #   rule {
  #     name                = "xrdp"
  #     protocols           = ["TCP"]
  #     source_addresses    = ["*"]
  #     destination_address = azurerm_firewall.hubs["canadacentral"].virtual_hub[0].public_ip_addresses[0]
  #     destination_ports   = ["2023"]
  #     translated_address  = "10.1.255.4"
  #     translated_port     = "2023"
  #   }
  # }

# 	application_rule_collection {
#     name     = "allowAllHttpHttpsOutJumpbox"
#     priority = 110
#     action   = "Allow"

#     rule {
#       name = "allowAllJumpboxOutbound"
      
# 			protocols {
#         type = "Http"
#         port = 80
#       }

#       protocols {
#         type = "Https"
#         port = 443
#       }
      
# 			source_addresses  = [
# 				var.jumpbox_subnet_cidr
# 			]
      
# 			destination_fqdns = [
# 				"*"
# 			]
#     }
#   }
# }


resource "azurerm_firewall_policy_rule_collection_group" "vpn-p2s" {
  for_each = {
		for idx, region in var.virtual_hub_regions: region => idx
	}
	name               = "vpn-p2s-fwpolicy-${each.key}-rcg"
  firewall_policy_id = azurerm_firewall_policy.hubs[each.key].id
  priority           = 200

	network_rule_collection {
		name = "p2s-vpn-allow-all-outbound"
		priority = 100
		action = "Allow"

		rule {
			name = "all"
			protocols = ["Any"]
			source_addresses = azurerm_point_to_site_vpn_gateway.p2s[each.key].connection_configuration[0].vpn_client_address_pool[0].address_prefixes
			destination_ports = ["*"]
			destination_addresses = ["*"]
		} 
	}
}

resource "azurerm_firewall_policy_rule_collection_group" "aca" {
  for_each = {
		for idx, region in var.virtual_hub_regions: region => idx
	}
	name               = "fwpolicy-aca-rcg"
	firewall_policy_id = azurerm_firewall_policy.hubs[each.key].id
  	priority           = 300

	network_rule_collection {
		name = "aca-network-allow-all-outbound"
		priority = 100
		action = "Allow"

		rule {
			name = "all-network"
			protocols = ["Any"]
			source_addresses = [
				"10.255.8.0/23"
			]
			destination_ports = ["*"]
			destination_addresses = ["*"]
		} 
	}

	application_rule_collection {
	  name = "aca-app-allow-all-outbound"
	  priority = 200
	  action = "Allow"

	  rule {
		name = "all-http"

		protocols {
		  type = "Https"
		  port = 443
		}

		protocols {
		  type = "Http"
		  port = 80
		}

		source_addresses = [
			"10.255.8.0/23"
		]
		destination_fqdns = ["*"]
	  }
	}


# 	application_rule_collection {
#     name     = "acaAppRules"
#     priority = 100
#     action   = "Allow"

#     rule {
#       	name = "hcp"

# 		protocols {
# 			type = "Https"
# 			port = 443
# 		}
      
# 		source_addresses  = ["*"]
# 		destination_fqdns = [
# 			"*.hcp.${each.key}.azmk8s.io"
# 		]
#     }

# 	rule {
#       	name = "mcr"

# 		protocols {
# 			type = "Https"
# 			port = 443
# 		}
      
# 		source_addresses  = ["*"]
# 		destination_fqdns = [
# 			"mcr.microsoft.com",
# 			"*.data.mcr.microsoft.com"
# 		]
#     }

# 	rule {
# 		name = "ubuntu"
# 		protocols {
# 		  type = "Http"
# 		  port = 80
# 		}

# 		protocols {
# 		  type = "Https"
# 		  port = 443
# 		}

# 		source_addresses = ["*"]
# 		destination_fqdns = [
# 			"security.ubuntu.com",
# 			"azure.archive.ubuntu.com",
# 			"*.azure.archive.ubuntu.com",
# 			"changelogs.ubuntu.com",
# 			"motd.ubuntu.com",
# 			"*.opensuse.org",
# 		]
# 	}

# 	rule {
#       	name = "azure"

# 		protocols {
# 			type = "Https"
# 			port = 443
# 		}
      
# 		source_addresses  = ["*"]
# 		destination_fqdns = [
# 			"management.azure.com",
# 			"login.microsoftonline.com",
# 			"packages.microsoft.com",
# 			"acs-mirror.azureedge.net",
# 			"dc.services.visualstudio.com",
# 			"graph.microsoft.com",
# 			"aka.ms",
# 			"*.microsoft.com",
#       "*.blob.core.windows.net",
#       "*.blob.storage.azure.net",
# 		]
#     }

# 	rule {
#       	name = "azure-monitor"

# 		protocols {
# 			type = "Https"
# 			port = 443
# 		}
      
# 		source_addresses  = ["*"]
# 		destination_fqdns = [
# 			"*.ods.opinsights.azure.com",
# 			"*.oms.opinsights.azure.com",
# 			"*.monitoring.azure.com",

# 		]
#     }

# 	rule {
#       	name = "azure-policy"

# 		protocols {
# 			type = "Https"
# 			port = 443
# 		}
      
# 		source_addresses  = ["*"]
# 		destination_fqdns = [
# 			"data.policy.core.windows.net",
# 			"store.policy.core.windows.net",
# 			"dc.services.visualstudio.com"
# 		]
#     }

# 	rule {
#       	name = "aks"

# 		protocols {
# 			type = "Https"
# 			port = 443
# 		}
      
# 		source_addresses  = ["*"]
# 		destination_fqdn_tags = ["AzureKubernetesService"]
		
#     }
#   }
}