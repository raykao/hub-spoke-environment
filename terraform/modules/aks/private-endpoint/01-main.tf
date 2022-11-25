terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"

    }
  }
}

locals {
  name = "${prefix}${name}"
}