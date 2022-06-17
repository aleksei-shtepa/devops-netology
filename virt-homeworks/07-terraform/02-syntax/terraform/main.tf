provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  zone      = var.yc_region
}

resource "yandex_compute_image" "test-image" {
  name       = "netology-test-image"
  source_family = "centos-8"
}
