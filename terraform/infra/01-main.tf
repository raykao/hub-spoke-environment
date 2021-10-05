terraform {
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"
			version = "~> 2.78.0"
		}

		azuread = {
      source = "hashicorp/azuread"
      version = "2.5.0"
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
	# global = data.terraform_remote_state.global.outputs
  prefix = var.prefix
  location = "eastus"
  admin_username = "${local.prefix}admin"
}