terraform {
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"
		}
		azapi = {
			source = "Azure/azapi"
			version = "~> 1.0.0"
		}
	}
}

data "azurerm_client_config" "current" {
}


data "http" "myip" {
  url = "https://ipv4.icanhazip.com/"
}

locals {
    prefix = "${var.prefix}${var.region}"

	myip = trimspace(data.http.myip.response_body)

    hub_cidr    = cidrsubnet(var.region_cidr_range, 8, 0)
    spoke1_cidr = cidrsubnet(var.region_cidr_range, 8, 1)
    spoke2_cidr = cidrsubnet(var.region_cidr_range, 8, 2)
    spoke3_cidr = cidrsubnet(var.region_cidr_range, 8, 3)
    spoke4_cidr = cidrsubnet(var.region_cidr_range, 8, 4)
    spoke5_cidr = cidrsubnet(var.region_cidr_range, 8, 5)
    spoke6_cidr = cidrsubnet(var.region_cidr_range, 8, 6)
}