variable "prefix" {
  type = string
  default = "rk"
}

variable "subId1" {
  type = string
}

variable "subId2" {
  type = string
}

variable "onprem_cidr" {
  type = string
  default = "10.0.0.0/24"
}

variable "global_address_space" {
  type = string
  default = "10.0.0.0/8"
}

variable "domain" {
  type = string
}

variable "admin_username" {
  type = string
  default = "gbbadmin"
}

variable "admin_email" {
  type = string
}

variable "admin_groups" {
  
}