resource "yandex_kubernetes_cluster" "k8s-zonal" {
  network_id = yandex_vpc_network.default.id
  master {
    version = local.k8s_version
    zonal {
      zone      = yandex_vpc_subnet.default.zone
      subnet_id = yandex_vpc_subnet.default.id
    }
    public_ip = true
    # security_group_ids = [yandex_vpc_security_group.k8s-public-services.id]
  }
  service_account_id      = yandex_iam_service_account.sa-netology.id
  node_service_account_id = yandex_iam_service_account.sa-netology.id
  depends_on = [
    yandex_resourcemanager_folder_iam_binding.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_binding.vpc-public-admin,
    yandex_resourcemanager_folder_iam_binding.images-puller,
    yandex_resourcemanager_folder_iam_binding.editor
  ]
  kms_provider {
    key_id = yandex_kms_symmetric_key.kms-key.id
  }
}

resource "yandex_resourcemanager_folder_iam_binding" "k8s-clusters-agent" {
  # Сервисному аккаунту назначается роль "k8s.clusters.agent".
  folder_id = var.yc_folder_id
  role      = "k8s.clusters.agent"
  members = [
    "serviceAccount:${yandex_iam_service_account.sa-netology.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "vpc-public-admin" {
  # Сервисному аккаунту назначается роль "vpc.publicAdmin".
  folder_id = var.yc_folder_id
  role      = "vpc.publicAdmin"
  members = [
    "serviceAccount:${yandex_iam_service_account.sa-netology.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
  # Сервисному аккаунту назначается роль "container-registry.images.puller".
  folder_id = var.yc_folder_id
  role      = "container-registry.images.puller"
  members = [
    "serviceAccount:${yandex_iam_service_account.sa-netology.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
 # Сервисному аккаунту назначается роль "editor".
 folder_id = var.yc_folder_id
 role      = "editor"
 members   = [
   "serviceAccount:${yandex_iam_service_account.sa-netology.id}"
 ]
}

resource "yandex_kms_symmetric_key" "kms-key" {
  # Ключ для шифрования важной информации, такой как пароли, OAuth-токены и SSH-ключи.
  name              = "kms-key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 год.
}

resource "yandex_kms_symmetric_key_iam_binding" "viewer" {
  symmetric_key_id = yandex_kms_symmetric_key.kms-key.id
  role             = "viewer"
  members = [
    "serviceAccount:${yandex_iam_service_account.sa-netology.id}",
  ]
}
