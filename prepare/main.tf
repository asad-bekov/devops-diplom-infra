terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "yandex" {
  folder_id = var.folder_id
  token     = var.yc_token
}

# Сервисный аккаунт для Terraform
resource "yandex_iam_service_account" "terraform" {
  name        = "terraform-sa"
  description = "Service account for Terraform"
}

# Роли для сервисного аккаунта
resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.terraform.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc_admin" {
  folder_id = var.folder_id
  role      = "vpc.admin"
  member    = "serviceAccount:${yandex_iam_service_account.terraform.id}"
}

# Ключ для сервисного аккаунта
resource "yandex_iam_service_account_key" "terraform_key" {
  service_account_id = yandex_iam_service_account.terraform.id
  description        = "Static key for Terraform SA"
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# S3 бакет для Terraform state
resource "yandex_storage_bucket" "tf_state" {
  bucket = "diploma-terraform-state-${random_id.bucket_suffix.hex}"
  
  versioning {
    enabled = true
  }
}

# Сохраняем ключ локально в JSON
resource "local_file" "sa_key_json" {
  filename = "${path.module}/sa-key.json"
  content  = yandex_iam_service_account_key.terraform_key.private_key
}

# Сохраняем информацию о bucket в файл
resource "local_file" "bucket_info" {
  filename = "${path.module}/bucket-info.txt"
  content  = <<-EOT
  bucket_name: ${yandex_storage_bucket.tf_state.bucket}
  service_account_id: ${yandex_iam_service_account.terraform.id}
  key_id: ${yandex_iam_service_account_key.terraform_key.id}
  EOT
}
