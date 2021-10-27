terraform {
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"

		}
	}
}

locals {
	prefix = "${var.prefix}${local.region}"
	region = "spoke4"
}