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

variable "global_address_space" {
  type = string
  default = "10.0.0.0/8"
}

variable "domain" {
  type = string
}

locals {
  prefix = "${var.prefix}demoenv"
  location = "eastus"
  admin_username = "${var.prefix}admin"
}