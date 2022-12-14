terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
    pkcs12 = {
      source = "chilicat/pkcs12"
      version = "0.0.7"
    }
  }
}

locals {
	prefix = var.prefix
  myip = trimspace(data.http.myip.response_body)
}

data "azurerm_client_config" "current" {
}

data "http" "myip" {
  url = "https://ipv4.icanhazip.com/"
}
