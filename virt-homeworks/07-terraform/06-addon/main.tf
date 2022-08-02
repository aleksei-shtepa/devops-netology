provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_region
}

output "access_key" {
  value = yandex_storage_bucket.for_state.access_key
  sensitive = true
}

output "secret_key" {
  value = yandex_storage_bucket.for_state.secret_key
  sensitive = true
}

output "bucket" {
  value = yandex_storage_bucket.for_state.bucket
  sensitive = true
}
