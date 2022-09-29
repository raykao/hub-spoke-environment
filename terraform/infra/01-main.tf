terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.23.0"
    }
	pkcs12 = {
      source = "chilicat/pkcs12"
      version = "0.0.7"
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

provider "pkcs12" {
  # Configuration options
}

locals {
	# global = data.terraform_remote_state.global.outputs
	prefix = var.prefix
	location = "eastus"
	admin_username = var.admin_username
	hub_cidr = cidrsubnet(var.global_address_space, 8, 255)
	jumpbox_cidr = cidrsubnet(local.hub_cidr, 8, 255)
	onprem_cidr = cidrsubnet(var.global_address_space, 16, 0)
	spoke1_cidr = cidrsubnet(var.global_address_space, 8, 1)
	spoke2_cidr = cidrsubnet(var.global_address_space, 8, 2)
	spoke3_cidr = cidrsubnet(var.global_address_space, 8, 3)
	spoke4_cidr = cidrsubnet(var.global_address_space, 8, 4)
}