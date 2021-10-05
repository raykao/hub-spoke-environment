variable "prefix" {
	type = string
}

variable "location" {
	type = string
	default = "canadacentral"
}

variable "contributor_msi" {
	default = ""
}

variable "admin_username" {
	type = string
	default = ""
}

variable "ssh_key" {
	type = string
	default = ""
}

variable "address_space" {
	type = string
}

variable "domain" {
	type = string
}

variable "hub" {
	
}

variable "admin_email" {
	type = string
}

variable "admin_groups" {
	
}