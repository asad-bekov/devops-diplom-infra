resource "yandex_vpc_network" "network" {
  name = "${var.project_name}-network"
}

resource "yandex_vpc_subnet" "subnet_a" {
  name           = "${var.project_name}-subnet-a"
  zone           = var.zone_a
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet_b" {
  name           = "${var.project_name}-subnet-b"
  zone           = var.zone_b
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}

resource "yandex_vpc_subnet" "subnet_c" {
  name           = "${var.project_name}-subnet-d"
  zone           = var.zone_c
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.30.0/24"]
}

resource "yandex_vpc_security_group" "k8s_sg" {
  name        = "k8s-security-group"
  network_id  = yandex_vpc_network.network.id
  
  ingress {
    description    = "SSH from student's IP"
    port           = 22
    protocol       = "TCP"
    v4_cidr_blocks = ["5.16.128.10/32"]
  }
  
  ingress {
    description    = "MyPC"
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
    description    = "1"
    port           = 6443
    protocol       = "TCP"
    v4_cidr_blocks = ["10.0.2.15/32"]
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
    description    = "Outbound traffic"
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    port           = 8472
    protocol       = "UDP"
    v4_cidr_blocks = ["192.168.0.0/16"]
  }
}
