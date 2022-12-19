variable "prefix" {
  type = string
}

variable "resource_group" {
}

variable "subnet_id" {
  type = string
}

variable "sku" {
  type    = string
  default = "Standard_D4s_v3"
}

variable "admin_username" {
  type    = string
  default = "gbbadmin"
}

variable "admin_password" {
  type = string
  default = ""
}

variable "caching" {
  type    = string
  default = "ReadOnly"
}

variable "storage_account_type" {
  type    = string
  default = "Standard_LRS"
}

variable "disk_size_gb" {
  type    = string
  default = "2048"
}

variable "secure_boot_enabled" {
  type = bool
  default = false
}

variable "vtpm_enabled" {
  type = bool
  default = false
}