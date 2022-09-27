terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.23.0"
    }
  }
}

locals {
	prefix = var.prefix
}

data "azurerm_client_config" "current" {
}

data "http" "myip" {
  url = "https://api.ipify.org/"
}
