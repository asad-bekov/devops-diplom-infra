terraform {
  backend "s3" {
    endpoint   = "https://storage.yandexcloud.net"
    bucket     = "diploma-terraform-state-9e948575"
    region     = "ru-central1"
    key        = "prod/terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
