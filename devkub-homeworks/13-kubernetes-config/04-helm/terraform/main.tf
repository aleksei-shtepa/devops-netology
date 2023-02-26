locals {
  k8s_version = "1.22"
  sa_name     = "sa-netology"
  nscale      = 3
  users       = "shtepa"  
}

variable "yc_token" { default = "" }
variable "yc_cloud_id" { default = "" }
variable "yc_folder_id" { default = "" }
variable "yc_region" { default = "ru-central1-b" }

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_region
}

resource "yandex_vpc_network" "default" {
  name = "net-netology"
}

resource "yandex_vpc_subnet" "default" {
  name = "subnet-netology"
  v4_cidr_blocks = ["10.0.0.0/16"]
  zone           = var.yc_region
  network_id     = yandex_vpc_network.default.id
}

resource "yandex_iam_service_account" "sa-netology" {
  name        = local.sa_name
  description = "Service account for homeworks"
}

resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    command = "yc managed-kubernetes cluster get-credentials --id ${yandex_kubernetes_cluster.k8s-zonal.id} --external"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm /home/shtepa/.kube/config"
  }

  depends_on = [
    yandex_kubernetes_cluster.k8s-zonal,
    yandex_kubernetes_node_group.netology
  ]
}

