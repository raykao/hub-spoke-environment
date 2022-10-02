terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.23.0"
    }
    azapi = {
      source = "Azure/azapi"
      version = "~> 1.0.0"
    }
  }
}


resource "random_string" "suffix" {
	length  = 4
	special = false
	numeric 	= false
	upper 	= false
}

locals {
  prefix = var.prefix
  suffix = random_string.suffix.result
  name = "${local.prefix}aca${local.suffix}"
}