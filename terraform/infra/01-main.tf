terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.23.0"
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
  admin_username = var.admin_username
  cidrs = {
	hub = cidrsubnet(var.global_address_space, 8, 255)
	onprem = cidrsubnet(var.global_address_space, 16, 0)
	spoke1 = cidrsubnet(var.global_address_space, 8, 1)
	spoke2 = cidrsubnet(var.global_address_space, 8, 2)
	spoke3 = cidrsubnet(var.global_address_space, 8, 3)
	spoke4 = cidrsubnet(var.global_address_space, 8, 4)
  }
}