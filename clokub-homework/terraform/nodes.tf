resource "yandex_kubernetes_node_group" "netology" {
  cluster_id = yandex_kubernetes_cluster.k8s-zonal.id
  name       = "netology-13"

  instance_template {
    # name       = "<шаблон имени узлов>"
    platform_id = "standard-v3"
    container_runtime {
     type = "containerd"
    }
    # labels {
    #   "<имя метки>"="<значение метки>"
    # }

    resources {
      memory = 2
      cores  = 2
      core_fraction = 50
    }

    boot_disk {
      type = "network-hdd"
      size = 50
    }

    network_interface {
      nat                = true
      subnet_ids         = ["${yandex_vpc_subnet.default.id}"]
    }

    scheduling_policy {
      preemptible = true
    }

    metadata = {
      ssh-keys = "${local.users}:${file("~/.ssh/id_ed25519.pub")}"
    }
  }

  scale_policy {
    fixed_scale {
      size = local.nscale
    }
  }
}
