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

variable "domain" {
	type = string
}

variable "firewall_ip" {
  type = string
}

variable "firewall_policy_id" {
  	type = string
}

variable "region" {
  type = string
}

variable "vwan_hub_id" {
	type = string
}

variable "admin_groups" {
	type = map
}

variable "onprem_dns_server" {
  type = string
}

variable "onprem_domain" {
  type = string
}

variable "global_private_zone" {
  type = map
}

variable "global_private_dns_zones" {
  type = map
}