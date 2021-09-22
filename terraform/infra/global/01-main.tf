terraform {
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"
			version = "~> 2.70.0"
		}
	}
}

locals {
	prefix = var.prefix
}