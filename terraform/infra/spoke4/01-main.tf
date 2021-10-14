terraform {
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"
			version = "~> 2.78.0"
		}
	}
}

locals {
	prefix = "${var.prefix}${local.region}"
	region = "spoke4"
}