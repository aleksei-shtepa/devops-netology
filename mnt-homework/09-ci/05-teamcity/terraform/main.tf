provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_region
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

module "instance" {
  source = "../modules/instance"
  
  for_each = toset(["sonar", "nexus"])

  name = each.key
  image = "centos-7"
  memory = 4
  subnet_id = yandex_vpc_subnet.subnet-1.id
  nat = true
}
