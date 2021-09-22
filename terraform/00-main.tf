terraform {
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"
			version = "~> 2.70.0"
		}
	}
}

provider azurerm {
	alias = "sub1"
	subscription_id = var.sub1SubscriptionId
	features {}
}

provider azurerm {
	alias = "sub2"
	subscription_id = var.sub2SubscriptionId
	features {}
}

variable "prefix" {
  type = string
  default = "rk"
}

variable "sub1SubscriptionId" {
  type = string
}

variable "sub2SubscriptionId" {
  type = string
}

variable "hub_address_space" {
  type = string
  default = "10.0.0.0/16"
}

variable "spoke1_address_space" {
  type = string
  default = "10.1.0.0/16"
}

variable "spoke2_address_space" {
  type = string
  default = "10.2.0.0/16"
}

variable "spoke3_address_space" {
  type = string
  default = "10.3.0.0/16"
}

variable "spoke4_address_space" {
  type = string
  default = "10.4.0.0/16"
}

variable "domain" {
  type = string
}

variable "location1" {
  type = string
}

variable "location2" {
  type = string
}

variable "location3" {
  type = string
}

locals {
  prefix = "${var.prefix}demoenv"
  location = "eastus"
  admin_username = "${var.prefix}admin"
}

output sub1SubscriptionId {
	value = var.sub1SubscriptionId
}

output sub2SubscriptionId {
	value = var.sub2SubscriptionId
}

output hub {
	value = {
		jumpboxip = module.hub-jumpbox.ip
		jumpboxfqdn = module.hub-jumpbox.fqdn
		ssh	= "ssh -p 2022 ${local.admin_username}@${module.hub-jumpbox.ip}"
	}
}

output spoke1 {
	value = {
		aksCluster = {
			clusterName = azurerm_kubernetes_cluster.spoke1.name
			clusterRgName = azurerm_resource_group.spoke1.name
		}
	}
}

output spoke2 {
	value = {
		storageAccountName = azurerm_storage_account.spoke2.name
		fileShareName = azurerm_storage_share.spoke2.name
		# storageAccountAccessKey = {
		# 	value = azurerm_storage_account.spoke2.primary_access_key
		# 	sensitive = true
		# }
		storageServerFQDN = azurerm_private_endpoint.storage-spoke2.private_dns_zone_configs[0].record_sets[0].fqdn
	}
}

output spoke4 {
	value = {
		jumpboxip = module.spoke4-jumpbox.ip
		jumpboxfqdn = module.spoke4-jumpbox.fqdn
		ssh	= "ssh -p 2022 ${local.admin_username}@${module.spoke4-jumpbox.ip}"
	}
}