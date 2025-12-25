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

resource "yandex_iam_service_account" "terraform" {
  name        = "terraform-sa"
  description = "Service account for Terraform"
}

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

resource "yandex_iam_service_account_key" "terraform_key" {
  service_account_id = yandex_iam_service_account.terraform.id
  description        = "Static key for Terraform SA"
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "yandex_storage_bucket" "tf_state" {
  bucket = "diploma-terraform-state-${random_id.bucket_suffix.hex}"
  
  versioning {
    enabled = true
  }
}

resource "local_file" "sa_key_json" {
  filename = "${path.module}/sa-key.json"
  content  = yandex_iam_service_account_key.terraform_key.private_key
}

resource "local_file" "bucket_info" {
  filename = "${path.module}/bucket-info.txt"
  content  = <<-EOT
  bucket_name: ${yandex_storage_bucket.tf_state.bucket}
  service_account_id: ${yandex_iam_service_account.terraform.id}
  key_id: ${yandex_iam_service_account_key.terraform_key.id}
  EOT
}
