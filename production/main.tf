terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
  token     = var.yc_token
}

# Модуль VPC
module "vpc" {
  source = "./modules/vpc"
  
  project_name = var.project_name
  zone_a       = "ru-central1-a"
  zone_b       = "ru-central1-b"
  zone_c       = "ru-central1-d"
  network_cidr = "192.168.0.0/16"
}

# Модуль compute
module "compute" {
  source = "./modules/compute"
  
  project_name        = var.project_name
  zone_a              = "ru-central1-a"
  zone_b              = "ru-central1-b"
  zone_c              = "ru-central1-d"
  vpc_network_id      = module.vpc.network_id
  subnet_a_id         = module.vpc.subnet_a_id
  subnet_b_id         = module.vpc.subnet_b_id
  subnet_c_id         = module.vpc.subnet_c_id
  security_group_id   = module.vpc.security_group_id
}

# Модуль registry
module "registry" {
  source = "./modules/registry"
  
  project_name = var.project_name
  folder_id    = var.folder_id
}

# Outputs
output "master_ip" {
  value = module.compute.master_ip
}

output "worker_ips" {
  value = module.compute.worker_ips
}

output "registry_id" {
  value = module.registry.registry_id
}
