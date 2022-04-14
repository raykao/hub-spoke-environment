variable "prefix" {
	type = string
}

variable "location" {
	type = string
	default = "canadacentral"
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