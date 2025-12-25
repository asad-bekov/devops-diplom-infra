resource "yandex_container_registry" "diploma_registry" {
  name = "${var.project_name}-registry"
}

resource "yandex_container_repository" "app_repo" {
  name = "${yandex_container_registry.diploma_registry.id}/diploma-app"
}
