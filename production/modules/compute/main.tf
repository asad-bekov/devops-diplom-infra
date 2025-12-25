# Мастер нода (используем СУЩЕСТВУЮЩИЕ параметры!)
resource "yandex_compute_instance" "k8s_master" {
  name                      = "k8s-master"  # Оставляем существующее имя!
  platform_id               = "standard-v3"
  zone                      = var.zone_a
  
  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20  # Существующее значение!
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk"  # Существующий image_id!
      size     = 20                      # Существующий размер!
    }
  }

  network_interface {
    subnet_id = var.subnet_a_id
    nat       = true
    security_group_ids = [var.security_group_id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  scheduling_policy {
    preemptible = true  # Существующая настройка!
  }
}

# Worker ноды (используем СУЩЕСТВУЮЩИЕ параметры!)
resource "yandex_compute_instance" "k8s_worker" {
  count = 2
  name  = "k8s-worker-${count.index + 1}"  # Существующие имена!
  platform_id = "standard-v3"
  zone  = count.index == 0 ? var.zone_a : var.zone_b

  scheduling_policy {
    preemptible = true  # Прерываемые инстансы
  }

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20  # Существующее значение!
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk"  # Существующий image_id!
      size     = 20                      # Существующий размер!
    }
  }

  network_interface {
    subnet_id = count.index == 0 ? var.subnet_a_id : var.subnet_b_id
    nat       = true
    security_group_ids = [var.security_group_id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
