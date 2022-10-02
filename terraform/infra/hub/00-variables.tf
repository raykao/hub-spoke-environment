variable "prefix" {
	type = string
}

variable "location" {
	type = string
}

variable "admin_username" {
	type = string
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

variable "firewall_policy_id" {
  	type = string
}

variable "region" {
  type = string
  default = "hub"
}