resource "yandex_vpc_network" "network" {
  name = "${var.project_name}-network"
}

resource "yandex_vpc_subnet" "this" {
  for_each = var.subnets

  name           = "${var.project_name}-${each.key}"
  zone           = each.value.zone
  v4_cidr_blocks = [each.value.cidr]
  network_id     = yandex_vpc_network.network.id
}

resource "yandex_vpc_security_group" "k8s_sg" {
  name       = "k8s-security-group"
  network_id = yandex_vpc_network.network.id

  ingress {
    description    = "SSH access (educational)"
    port           = 22
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "HTTP"
    port           = 80
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "HTTPS"
    port           = 443
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Kubernetes API Server"
    port           = 6443
    protocol       = "TCP"
    v4_cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    description    = "etcd server client API"
    from_port      = 2379
    to_port        = 2380
    protocol       = "TCP"
    v4_cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    description    = "Kubelet API"
    port           = 10250
    protocol       = "TCP"
    v4_cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    description    = "Flannel (VXLAN)"
    port           = 8472
    protocol       = "UDP"
    v4_cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    description    = "Calico (BGP)"
    port           = 179
    protocol       = "TCP"
    v4_cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    description    = "Calico (Typha)"
    port           = 5473
    protocol       = "TCP"
    v4_cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    description    = "NodePort Services"
    from_port      = 30000
    to_port        = 32767
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Allow all outbound traffic"
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

