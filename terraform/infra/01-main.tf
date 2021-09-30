terraform {
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"
			version = "~> 2.78.0"
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

data terraform_remote_state global {
	backend= "local"

	config = {
		path = "${path.module}/global/terraform.tfstate"
	}
}

locals {
	global = data.terraform_remote_state.global.outputs
  prefix = local.global.prefix
  location = "eastus"
  admin_username = "${local.prefix}admin"
}