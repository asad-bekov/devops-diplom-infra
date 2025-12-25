variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
  default     = "b1gsj7sfde79kl5qkpbl"
}

variable "folder_id" {
  description = "Yandex Cloud folder ID"
  type        = string
  default     = "b1gm0hnoge59gnkmh3dl"
}

variable "yc_token" {
  type        = string
  description = "Yandex Cloud OAuth token"
  sensitive   = true
}

variable "project_name" {
  type        = string
  description = "Project name for resources naming"
  default     = "diploma"
}
