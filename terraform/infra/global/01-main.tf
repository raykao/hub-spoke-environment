terraform {
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"

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
