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