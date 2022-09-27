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
	region = "spoke2"
}

data "http" "myip" {
  url = "https://api.ipify.org/"
}
