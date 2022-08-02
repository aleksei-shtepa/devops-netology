# Создание сервисного аккаунта
resource "yandex_iam_service_account" "resource" {
  name        = "robot-resource"
  description = "testing service account"
}

# Назначаем сервисному аккаунту роль
resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.yc_folder_id

  role = "editor"

  members = [
    "serviceAccount:${yandex_iam_service_account.resource.id}",
  ]
}

# Создаём статические ключи доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.resource.id
  description        = "static access key for object storage"
}

# Создаём корзину для объектного хранилища
resource "yandex_storage_bucket" "for_state" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
}

resource "local_file" "access_key" {
    content  = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    filename = "access_key"
    file_permission = "0640"
}

resource "local_file" "secret_key" {
    content  = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    filename = "secret_key"
    file_permission = "0640"
}

resource "local_file" "bucket" {
    content  = yandex_storage_bucket.for_state.bucket
    filename = "bucket"
    file_permission = "0640"
}
