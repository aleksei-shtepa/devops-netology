variable "yc_token" { default = "" }
variable "yc_cloud_id" { default = "" }
variable "yc_folder_id" { default = "" }
variable "yc_region" { default = "ru-central1-b" }
variable "nat_gateway" { default = "192.168.10.254" }

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      #   version = ">= 0.70"
    }
  }
  #   required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_region
}

resource "yandex_vpc_network" "default" {
  name = "default-network"
}

resource "yandex_vpc_subnet" "public" {
  name           = "public"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = var.yc_region
  network_id     = yandex_vpc_network.default.id
}

resource "yandex_vpc_subnet" "private" {
  name           = "private"
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = var.yc_region
  network_id     = yandex_vpc_network.default.id
  route_table_id = yandex_vpc_route_table.router.id
}

resource "yandex_vpc_route_table" "router" {
  name       = "route-table"
  network_id = yandex_vpc_network.default.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = module.vm-nat-gateway.internal_ip
  }
}

module "vm-nat-gateway" {
  source      = "../modules/instance"
  users       = "ubuntu"
  name        = "gateway"
  description = "Gateway"
  ip          = var.nat_gateway
  nat         = "true"
  subnet_id   = yandex_vpc_subnet.public.id
  image_id    = "fd80mrhj8fl2oe87o4e1"
  disk_size   = 10
}

module "vm-public" {
  source      = "../modules/instance"
  users       = "debian"
  name        = "public-vm"
  description = "Machine in public subnet"
  ip          = ""
  nat         = true
  subnet_id   = yandex_vpc_subnet.public.id
  disk_size   = 10
}

module "vm-private" {
  source      = "../modules/instance"
  users       = "debian"
  name        = "private-vm"
  description = "Machine in private subnet"
  ip          = ""
  nat         = false
  subnet_id   = yandex_vpc_subnet.private.id
  disk_size   = 10
}

output "SSH_Bastion" {
  value = "ssh -J ${module.vm-nat-gateway.user}@${module.vm-nat-gateway.external_ip} ${module.vm-private.user}@${module.vm-private.internal_ip}"
}
