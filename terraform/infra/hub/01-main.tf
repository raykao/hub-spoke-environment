terraform {
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"
		}
	}
}

locals {
	prefix = var.prefix
	bind9_address_space = cidrsubnet(var.address_space, 8, 2)
	region = "hub"
}

data "azurerm_client_config" "current" {
}