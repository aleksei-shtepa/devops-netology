variable image { default =  "centos-7" }
variable name { default = "" }
variable description { default =  "" }
variable instance_role { default =  "all" }
variable users { default = "centos" }
variable cores { default = 2 }
variable platform_id { default = "standard-v1" }
variable memory { default = 2 }
variable core_fraction { default = "20" }
variable subnet_id { default = "" }
variable nat { default = false }
variable instance_count { default = 1 }
variable count_offset { default = 0 } #start numbering from X+1 (e.g. name-1 if '0', name-3 if '2', etc.)
variable count_format { default = "%01d" } #server number format (-1, -2, etc.)
variable boot_disk { default =  "network-hdd" }
variable disk_size { default =  "10" }
variable zone { default =  "" }
variable folder_id { default =  "" }

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.76.0"
    }
  }
}

data "yandex_compute_image" "image" {
  family = var.image
}

resource "yandex_compute_instance" "instance" {
  name = var.name
  platform_id = var.platform_id
  hostname = var.name
  description = var.description != "" ? var.description : var.name
  zone = var.zone
  folder_id = var.folder_id

  resources {
    cores  = var.cores
    memory = var.memory
    core_fraction = var.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
      type = var.boot_disk
      size = var.disk_size
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = var.nat
  }

  metadata = {
    ssh-keys = "${var.users}:${file("~/.ssh/id_ed25519.pub")}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "ip" {
  value = yandex_compute_instance.instance.network_interface.0.nat_ip_address
  description = "Host IP adress"
}

output "user" {
  value = var.users
  description = "OS default user"
}