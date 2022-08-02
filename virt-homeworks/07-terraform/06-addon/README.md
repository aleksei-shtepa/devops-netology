# Terraform-проект создания корзины объектного хранилища, iam-роли и пользователя

Проект является подготовительным для применения в других проектах использующих s3-backend.

## Зависимости

Должен быть установлен Yandex Disk CLI и настроен биллинговый аккаунт:

```bash
 ~/w/n/d/v/0/0/terraform_s3 ❯ yc config list
token: xxxxxxxxxxxx
cloud-id: xxxxxxxxxxxx
folder-id: xxxxxxxxxxxx
compute-default-zone: xxxxxxxxxxxx
```

## Сборка

Для сборки проекта необходимо передать через переменные окружения значения **yc_token**, **yc_cloud_id** и **yc_folder_id**:

```bash
terraform init -var="yc_token=$(yc config get token)" -var="yc_cloud_id=$(yc config get cloud-id)" -var="yc_folder_id=$(yc config get folder-id)"

terraform plan -var="yc_token=$(yc config get token)" -var="yc_cloud_id=$(yc config get cloud-id)" -var="yc_folder_id=$(yc config get folder-id)"

terraform apply -auto-approve -var="yc_token=$(yc config get token)" -var="yc_cloud_id=$(yc config get cloud-id)" -var="yc_folder_id=$(yc config get folder-id)"
```
