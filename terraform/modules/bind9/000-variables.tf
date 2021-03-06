variable "prefix" {
  type = string
}

variable "vnet_address_spaces" {
  type = list(string)
}

variable "subnet_id" {
  type = string
}

variable "resource_group" {
}

variable "sku" {
  type = string
  default = "Standard_A1_v2"
}

variable "admin_username" {
  type = string
  default = "raykao"
}

variable "ssh_key" {
  type = string
}

variable "admin_subnet_prefix" {
  type = string
}