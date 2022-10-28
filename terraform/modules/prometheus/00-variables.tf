variable "prefix" {
	type = string
}

variable "resource_group" {
}

variable "subnet_id" {
	type = string
}

variable "type" {
	type = string
	default = "private"
}

variable "admin_username" {
  type = string
}

variable "admin_public_key" {
	type = string
}

variable "user_msi_id" {
  type = string
}

variable "vm_size" {
    type = string
    default = "Standard_D4s_v3"
}

variable "private_dns_zone_id" {
	type = string
}

variable "suffix" {
  type = string
}

variable "admin_group_object_ids" {
	type = list
	default = []
}