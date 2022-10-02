terraform {
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"
		}
		azapi = {
			source = "Azure/azapi"
			version = "~> 1.0.0"
		}
	}
}

locals {
	prefix = var.prefix
	region = var.region
	name = "${var.prefix}${local.region}"
	bind9_address_space = cidrsubnet(var.address_space, 8, 2)
}

data "azurerm_client_config" "current" {
}