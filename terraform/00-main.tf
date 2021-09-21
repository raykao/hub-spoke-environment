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
  prefix = "${var.prefix}csitest"
  location = "eastus"
  admin_username = "${var.prefix}admin"
}

output sub1SubscriptionId {
	value = var.sub1SubscriptionId
}

output sub2SubscriptionId {
	value = var.sub2SubscriptionId
}

output storageAccountName {
	value = azurerm_storage_account.spoke2.name
}

output fileShareName {
	value = azurerm_storage_share.spoke2.name
}

output storageAccountAccessKey {
	value = azurerm_storage_account.spoke2.primary_access_key
	sensitive = true
}

output "storageServerFQDN" {
  value = azurerm_private_endpoint.storage-spoke2.private_dns_zone_configs[0].record_sets[0].fqdn
}

output clusterName {
	value = azurerm_kubernetes_cluster.spoke1.name
}

output clusterRgName {
	value = azurerm_resource_group.spoke1.name
}

output jumpboxIp {
	value = azurerm_public_ip.jumpbox.ip_address
}

output jumpboxFQDN {
	value = azurerm_public_ip.jumpbox.fqdn
}