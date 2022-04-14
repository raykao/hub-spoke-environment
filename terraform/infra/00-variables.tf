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

variable "global_address_space" {
  type = string
  default = "10.0.0.0/8"
}

variable "domain" {
  type = string
}

variable "admin_email" {
  type = string
}

variable "admin_groups" {
  
}

variable "onprem_cidr" {
  type = string
}