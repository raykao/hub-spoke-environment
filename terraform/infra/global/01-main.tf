terraform {
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"
			version = "~> 2.78.0"
		}
	}
}


provider "azurerm" {
  # Configuration options
	features {
		
	}
}

locals {
	prefix = var.prefix
}

data "azurerm_client_config" "current" {
}