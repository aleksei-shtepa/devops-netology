provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_region
}

data "yandex_compute_image" "image" {
  family = "fedora-35"
}

resource "yandex_compute_instance" "clickhouse" {
  name = "clickhouse"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
      type = "network-hdd"
      size = "10"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "shtepa:${file("~/.ssh/id_ed25519.pub")}"
  }
}

resource "yandex_compute_instance" "vector" {
  name = "vector"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
      type = "network-hdd"
      size = "10"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }


  metadata = {
    ssh-keys = "shtepa:${file("~/.ssh/id_ed25519.pub")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network82"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet82"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "clickhouse" {
  value = yandex_compute_instance.clickhouse.network_interface.0.nat_ip_address
}

output "vector" {
  value = yandex_compute_instance.vector.network_interface.0.nat_ip_address
}

# output "internal_ip_address_vm_1" {
#   value = yandex_compute_instance.clickhouse.network_interface.0.ip_address
# }

# output "internal_ip_address_vm_2" {
#   value = yandex_compute_instance.vector.network_interface.0.ip_address
# }

# output "subnet-1" {
#   value = yandex_vpc_subnet.subnet-1.id
# }

# output "user" {
#   value = yandex_compute_instance.clickhouse.metadata
# }
