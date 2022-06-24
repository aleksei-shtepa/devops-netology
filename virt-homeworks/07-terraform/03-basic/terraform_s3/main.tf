provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_region
}

terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    key        = "terraform-07/basic-03.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true

    bucket     = "xxx"
    access_key = "yyy"
    secret_key = "zzz"
  } 
}

module "vpc" {
  source  = "hamnsk/vpc/yandex"
  version = "0.5.0"
  description = "managed by terraform"
  create_folder = length(var.yc_folder_id) > 0 ? false : true
  yc_folder_id = var.yc_folder_id
  name = terraform.workspace
  subnets = local.vpc_subnets[terraform.workspace]
}


module "instance_count" {
  source = "../modules/instance"
  instance_count = local.instance_count[terraform.workspace]

  subnet_id     = module.vpc.subnet_ids[0]
  zone = var.yc_region
  folder_id = module.vpc.folder_id
  platform_id   = "standard-v2"
  name          = "testinstance"
  description   = "Test instance Demo"
  instance_role = "testing"
  users         = "centos"
  cores         = local.cores[terraform.workspace]
  boot_disk     = "network-ssd"
  disk_size     = local.disk_size[terraform.workspace]
  nat           = "true"
  memory        = "2"
  core_fraction = "100"
  depends_on = [
    module.vpc
  ]
}

module "instance_for_each" {
  source = "../modules/instance"

  for_each = local.nodes_name

  subnet_id     = module.vpc.subnet_ids[0]
  zone = var.yc_region
  folder_id = module.vpc.folder_id
  platform_id   = "standard-v2"
  name          = "${each.key}"
  description   = "${each.value}"
  instance_role = "testing"
  users         = "centos"
  cores         = local.cores[terraform.workspace]
  boot_disk     = "network-ssd"
  disk_size     = local.disk_size[terraform.workspace]
  nat           = "true"
  memory        = "2"
  core_fraction = "100"
  depends_on = [
    module.vpc
  ]
}

