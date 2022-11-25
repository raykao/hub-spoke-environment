variable "prefix" {
 type = string 
}

variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "auto_approval_subscription_ids" {
  type = list
}

variable "visibility_subscription_ids" {
  type = list
}