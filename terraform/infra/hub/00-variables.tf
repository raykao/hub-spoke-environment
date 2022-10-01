variable "prefix" {
	type = string
}

variable "location" {
	type = string
	default = "canadacentral"
}

variable "admin_username" {
	type = string
	default = ""
}

variable "admin_email" {
	type = string
}

variable "public_key" {
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