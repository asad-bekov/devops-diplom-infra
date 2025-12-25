output "service_account_id" {
  value = yandex_iam_service_account.terraform.id
}

output "bucket_name" {
  value = yandex_storage_bucket.tf_state.bucket
}

output "sa_key_json" {
  value     = local_file.sa_key_json.content
  sensitive = true
}

output "bucket_info" {
  value = local_file.bucket_info.content
}
