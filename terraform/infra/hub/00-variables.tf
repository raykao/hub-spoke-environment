variable "prefix" {
	type = string
}

variable "location" {
	type = string
	default = "canadacentral"
}

variable "contributor_msi" {
}

variable "admin_username" {
	type = string
	default = ""
}

variable "ssh_key" {
	type = string
}

variable "address_space" {
	type = string
}

variable "global_address_space" {
	type = string
}

variable "domain" {
	type = string
}

variable "admin_email" {
	type = string
}