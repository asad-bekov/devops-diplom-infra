output "master_ip" {
  value = yandex_compute_instance.k8s_master.network_interface[0].nat_ip_address
}

output "master_internal_ip" {
  value = yandex_compute_instance.k8s_master.network_interface[0].ip_address
}

output "worker_ips" {
  value = yandex_compute_instance.k8s_worker[*].network_interface[0].nat_ip_address
}

output "worker_internal_ips" {
  value = yandex_compute_instance.k8s_worker[*].network_interface[0].ip_address
}
