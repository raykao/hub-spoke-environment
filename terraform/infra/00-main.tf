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
	subscription_id = var.subId1
	features {}
}

provider azurerm {
	alias = "sub2"
	subscription_id = var.subId2
	features {}
}

variable "prefix" {
  type = string
  default = "rk"
}

variable "subId1" {
  type = string
}

variable "subId2" {
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