variable "prefix" {
  type = string
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

variable "regions" {
  type = list
  default = [
    "canadacentral",
    "eastus"
  ]
}

variable "domain" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_email" {
  type = string
}

variable "admin_pub_ssh_key" {
  type = string
  default = "~/.ssh/id_rsa.pub"
  description = "Path to your id_rsa.pub"
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