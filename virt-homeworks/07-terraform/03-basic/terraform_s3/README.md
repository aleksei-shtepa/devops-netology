# Учебный Terraform-проект

1. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах использовались разные `instance_type`.
1. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два. 
1. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.
1. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.

## Зависимости

Terraform backend размещается в Yandex Object Storage. Для получения корзины и ключей доступа к ней используется проект [../terraform_local/](../terraform_local/)

Описание Узла (instance) оформлено в виде модуля [instance](../modules/instance/).

В файле проекта **main.tf**, в разделе **backend** необходимо заполнить данные для доступа к корзине Yandex Object Storage. Их нужно брать из файлов `../terraform_local/access_key`, `../terraform_local/secret_key` и `../terraform_local/bucket`.

## Сборка

Для сборки проекта необходимо передать через переменные окружения значения **yc_token**, **yc_cloud_id** и **yc_folder_id**:

```bash
terraform init -var="yc_token=$(yc config get token)" -var="yc_cloud_id=$(yc config get cloud-id)" -var="yc_folder_id=$(yc config get folder-id)"

terraform plan -var="yc_token=$(yc config get token)" -var="yc_cloud_id=$(yc config get cloud-id)" -var="yc_folder_id=$(yc config get folder-id)"

terraform apply -auto-approve -var="yc_token=$(yc config get token)" -var="yc_cloud_id=$(yc config get cloud-id)" -var="yc_folder_id=$(yc config get folder-id)"
```
