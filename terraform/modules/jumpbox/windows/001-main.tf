resource "random_password" "admin_password" {
  length  = 16
  min_upper   = 1
  min_lower   = 1
  min_numeric  = 1
  min_special = 1
}


resource "random_string" "suffix" {
	length  = 4
	special = false
	numeric 	= false
	upper 	= false
}

locals {
  prefix    = var.prefix
  suffix = random_string.suffix.result
  hostname = "${local.prefix}win${local.suffix}"
  admin_password = var.admin_password != "" ? var.admin_password : random_password.admin_password.result
}