terraform {
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"

		}
	}
}

locals {
	prefix = var.prefix
	region = "spoke1"
}

data "azurerm_subscription" "current" {
}