terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"

    }
  }
}


locals {
	prefix = var.prefix
	region = "spoke2"
}

data "http" "myip" {
  url = "https://ipv4.icanhazip.com/"
}
