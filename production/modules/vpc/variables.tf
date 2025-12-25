variable "project_name" {
  type = string
}

variable "zone_a" {
  type = string
}

variable "zone_b" {
  type = string
}

variable "zone_c" {
  type = string
}

variable "network_cidr" {
  type    = string
  default = "192.168.0.0/16"
}
