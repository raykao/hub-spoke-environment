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

variable "address_space" {
	type = string
}

variable "domain" {
	type = string
}

variable "priv-dns-zone-links" {
	type = map
}