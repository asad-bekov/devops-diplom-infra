output "network_id" {
  value = yandex_vpc_network.network.id
}

output "subnet_a_id" {
  value = yandex_vpc_subnet.subnet_a.id
}

output "subnet_b_id" {
  value = yandex_vpc_subnet.subnet_b.id
}

output "subnet_c_id" {
  value = yandex_vpc_subnet.subnet_c.id
}

output "security_group_id" {
  value = yandex_vpc_security_group.k8s_sg.id
}
