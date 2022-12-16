terraform {
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"

		}
	}
}

locals {
	prefix = "${var.prefix}s1"
}

data "azurerm_subscription" "current" {
}