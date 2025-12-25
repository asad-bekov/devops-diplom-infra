variable "project_name" {
  type = string
}
variable "zone_a" { type = string }
variable "zone_b" { type = string }
variable "zone_c" { type = string }
variable "vpc_network_id" { type = string }
variable "subnet_a_id" { type = string }
variable "subnet_b_id" { type = string }
variable "subnet_c_id" { type = string }
variable "security_group_id" { type = string }

variable "sa_key" {
  type        = string
  default     = ""
  description = "Optional service account key"
  sensitive   = true
}
