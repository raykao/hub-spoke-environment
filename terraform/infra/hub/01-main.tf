terraform {
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"
			version = "~> 2.78.0"
		}
	}
}

locals {
	prefix = var.prefix
	bind9_address_space = cidrsubnet(var.address_space, 8, 2)
}

data "azurerm_client_config" "current" {
}