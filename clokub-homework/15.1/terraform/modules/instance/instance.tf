variable "image" { default = "debian-11" }
variable "image_id" { default = "" }
variable "name" { default = "" }
variable "description" { default = "instance from terraform" }
variable "instance_role" { default = "all" }
variable "users" { default = "shtepa" }
variable "cores" { default = "2" }
variable "platform_id" { default = "standard-v1" }
variable "memory" { default = "2" }
variable "core_fraction" { default = "20" }
variable "subnet_id" { default = "" }
variable "nat" { default = "false" }
variable "ip" { default = "" }
variable "instance_count" { default = 1 }
variable "count_offset" { default = 0 }      #start numbering from X+1 (e.g. name-1 if '0', name-3 if '2', etc.)
variable "count_format" { default = "%01d" } #server number format (-1, -2, etc.)
variable "boot_disk" { default = "network-hdd" }
variable "disk_size" { default = "20" }
variable "zone" { default = "" }
variable "folder_id" { default = "" }

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      # version = "0.61.0"
    }
  }
}

data "yandex_compute_image" "image" {
  family = var.image
}

resource "yandex_compute_instance" "instance" {
  # count       = var.instance_count
  # name        = "${var.name}-${format(var.count_format, var.count_offset + count.index + 1)}"
  name        = "${var.name}"
  platform_id = var.platform_id
  # hostname    = "${var.name}-${format(var.count_format, var.count_offset + count.index + 1)}"
  hostname    = "${var.name}"
  description = var.description
  zone        = var.zone
  folder_id   = var.folder_id

  resources {
    cores         = var.cores
    memory        = var.memory
    core_fraction = var.core_fraction
  }

  boot_disk {
    device_name = var.users
    initialize_params {
      image_id = var.image_id != "" ? var.image_id : data.yandex_compute_image.image.id
      type     = var.boot_disk
      size     = var.disk_size
    }
  }

  network_interface {
    subnet_id  = var.subnet_id
    nat        = var.nat
    ip_address = var.ip
  }

  metadata = {
    ssh-keys = "${var.users}:${file("~/.ssh/id_ed25519.pub")}"
  }

  lifecycle {
    create_before_destroy = true
  }

  scheduling_policy {
    preemptible = true
  }
}

output "internal_ip" {
  value = "${yandex_compute_instance.instance.network_interface.0.ip_address}"
}

output "external_ip" {
  value = "${yandex_compute_instance.instance.network_interface.0.nat_ip_address}"
}

output "user" {
  value = var.users
}