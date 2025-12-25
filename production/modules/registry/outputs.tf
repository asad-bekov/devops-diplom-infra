output "registry_id" {
  value = yandex_container_registry.diploma_registry.id
}

output "repository_name" {
  value = yandex_container_repository.app_repo.name
}
