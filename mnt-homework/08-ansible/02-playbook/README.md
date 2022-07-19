# Домашнее задание к занятию "08.02 Работа с Playbook"

## Назначение

Плейбук разворачивает один экземпляр БД [Clickhouse](https://clickhouse.com) и один экземпляр агригатора логов и метрик [Vector](https://vector.dev) на динамически подключаемой инфраструктуре Яндекс Облака.

## Инфраструктура

Playbook использует инфраструктуру Yandex Cloud.

Инфраструктура разворачивается по средствам Terraform и динамически подключается к плейбуку.

Для активации инфраструктуры используется скрипт [infrastruct](./infrastruct):

```bash
./infrastruct init
./infrastruct apply
```

Для запуска плейбука:

```bash
./infrastruct playbook
```

В качестве параметров могут быть указаны версии [Clickhouse](./group_vars/clickhouse/vars.yml) и [Vector](./group_vars/vector/vars.yml).
