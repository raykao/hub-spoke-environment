terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"

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
	prefix = "${var.prefix}"
	suffix = random_string.suffix.result
	name = "${local.prefix}linux${local.suffix}"

	admin_username = var.admin_username
	admin_email = var.admin_email
	public_key = var.public_key != "" ? file(var.public_key) : tls_private_key.ssh[0].public_key_openssh
	create_public_key = var.public_key != "" ? false : true
}
