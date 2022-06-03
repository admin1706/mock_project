//------------- create Ubuntu 18.04 server ----------------//

variable "admin_username" {
  type     = string
  default  = "username"
}

variable "admin_password" {
  type     = string
  default  = "Password123!"
}

variable "location" {
  type     = string
}

variable "rg_tag" {
  type    = string
  default = "production"
}

variable "rg_name" {
  type    = string
}

variable "vm_name" {
  type    = string
}

variable "vm_name1" {
  type    = string
}

variable "vm_count" {
  default  = 1
}

variable "vm_image_string" {
  type    = string
}

variable "vm_image_string1" {
  type    = string
}

variable "vm_size" {
  type    = string
  default = "Standard_DS2_v2"
}

variable "vm_location" {
  type    = string
}