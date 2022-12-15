variable "prefix" {
  type = string
}

variable "resource_group" {
}

variable "subnet_id" {
	type = string
}

variable "vm_size" {
	type = string
	default = "Standard_D2s_v3"
}

variable "admin_username" {
	type = string
}

variable "public_key" {
	type = string
	default = ""
}

variable "admin_email" {
	type = string
}