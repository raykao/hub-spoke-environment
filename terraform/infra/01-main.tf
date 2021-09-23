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

locals {
  prefix = "${var.prefix}demoenv"
  location = "eastus"
  admin_username = "${var.prefix}admin"
}