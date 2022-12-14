terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.35.0"
    }
	azapi = {
      source = "Azure/azapi"
      version = "~> 1.0.0"
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

provider "azapi" {
  
}

locals {
	prefix = var.prefix

	admin_username = var.admin_username
	admin_email = var.admin_email
	public_key = var.admin_pub_ssh_key
	
	domain = var.domain

	global_address_space = var.global_address_space
	onprem_cidr = var.onprem_cidr
	
	hub_location = var.virtual_hub_regions[0]

	hub_cidr = cidrsubnet(local.global_address_space, 8, 255)	
	spoke1_cidr = cidrsubnet(local.global_address_space, 8, 1)
	spoke2_cidr = cidrsubnet(local.global_address_space, 8, 2)
	spoke3_cidr = cidrsubnet(local.global_address_space, 8, 3)
	spoke4_cidr = cidrsubnet(local.global_address_space, 8, 4)
}