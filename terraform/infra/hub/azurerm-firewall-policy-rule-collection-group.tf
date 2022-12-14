
# resource "azurerm_firewall_policy_rule_collection_group" "aca" {
#   	name               = "fwpolicy-aca-rcg"
# 	firewall_policy_id = azurerm_firewall_policy.hub.id
#   	priority           = 410

# 	network_rule_collection {
# 		name = "aca-network-allow-all-outbound"
# 		priority = 100
# 		action = "Allow"

# 		rule {
# 			name = "all-network"
# 			protocols = ["Any"]
# 			source_addresses = [
# 				"10.255.8.0/23"
# 			]
# 			destination_ports = ["*"]
# 			destination_addresses = ["*"]
# 		} 
# 	}

# 	application_rule_collection {
# 	  name = "aca-app-allow-all-outbound"
# 	  priority = 200
# 	  action = "Allow"

# 	  rule {
# 		name = "all-http"

# 		protocols {
# 		  type = "Https"
# 		  port = 443
# 		}

# 		protocols {
# 		  type = "Http"
# 		  port = 80
# 		}

# 		source_addresses = [
# 			"10.255.8.0/23"
# 		]
# 		destination_fqdns = ["*"]
# 	  }
# 	}



# # 	application_rule_collection {
# #     name     = "acaAppRules"
# #     priority = 100
# #     action   = "Allow"

# #     rule {
# #       	name = "hcp"

# # 		protocols {
# # 			type = "Https"
# # 			port = 443
# # 		}
      
# # 		source_addresses  = ["*"]
# # 		destination_fqdns = [
# # 			"*.hcp.${each.key}.azmk8s.io"
# # 		]
# #     }

# # 	rule {
# #       	name = "mcr"

# # 		protocols {
# # 			type = "Https"
# # 			port = 443
# # 		}
      
# # 		source_addresses  = ["*"]
# # 		destination_fqdns = [
# # 			"mcr.microsoft.com",
# # 			"*.data.mcr.microsoft.com"
# # 		]
# #     }

# # 	rule {
# # 		name = "ubuntu"
# # 		protocols {
# # 		  type = "Http"
# # 		  port = 80
# # 		}

# # 		protocols {
# # 		  type = "Https"
# # 		  port = 443
# # 		}

# # 		source_addresses = ["*"]
# # 		destination_fqdns = [
# # 			"security.ubuntu.com",
# # 			"azure.archive.ubuntu.com",
# # 			"*.azure.archive.ubuntu.com",
# # 			"changelogs.ubuntu.com",
# # 			"motd.ubuntu.com",
# # 			"*.opensuse.org",
# # 		]
# # 	}

# # 	rule {
# #       	name = "azure"

# # 		protocols {
# # 			type = "Https"
# # 			port = 443
# # 		}
      
# # 		source_addresses  = ["*"]
# # 		destination_fqdns = [
# # 			"management.azure.com",
# # 			"login.microsoftonline.com",
# # 			"packages.microsoft.com",
# # 			"acs-mirror.azureedge.net",
# # 			"dc.services.visualstudio.com",
# # 			"graph.microsoft.com",
# # 			"aka.ms",
# # 			"*.microsoft.com",
# #       "*.blob.core.windows.net",
# #       "*.blob.storage.azure.net",
# # 		]
# #     }

# # 	rule {
# #       	name = "azure-monitor"

# # 		protocols {
# # 			type = "Https"
# # 			port = 443
# # 		}
      
# # 		source_addresses  = ["*"]
# # 		destination_fqdns = [
# # 			"*.ods.opinsights.azure.com",
# # 			"*.oms.opinsights.azure.com",
# # 			"*.monitoring.azure.com",

# # 		]
# #     }

# # 	rule {
# #       	name = "azure-policy"

# # 		protocols {
# # 			type = "Https"
# # 			port = 443
# # 		}
      
# # 		source_addresses  = ["*"]
# # 		destination_fqdns = [
# # 			"data.policy.core.windows.net",
# # 			"store.policy.core.windows.net",
# # 			"dc.services.visualstudio.com"
# # 		]
# #     }

# # 	rule {
# #       	name = "aks"

# # 		protocols {
# # 			type = "Https"
# # 			port = 443
# # 		}
      
# # 		source_addresses  = ["*"]
# # 		destination_fqdn_tags = ["AzureKubernetesService"]
		
# #     }
# #   }
# }