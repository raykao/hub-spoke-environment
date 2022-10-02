variable "prefix" {
	type = string
}

variable "domain" {
	type = string
}

variable "admin_email" {
	type = string
}

variable "onprem_cidr" {
	type = string
}

variable "jumpbox_cidr" {
  type = string
}

variable "virtual_hub_regions" {
	type = list
	default = [
		"canadacentral"
	]
}

variable "client_cert_password" {
  type = string
  default = "mypassword"
}