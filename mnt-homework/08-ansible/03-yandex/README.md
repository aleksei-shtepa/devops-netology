# Домашнее задание к занятию "08.03 Использование Yandex Cloud"

## Назначение

Плейбук разворачивает один экземпляр БД [Clickhouse](https://clickhouse.com),
один экземпляр агригатора логов и метрик [Vector](https://vector.dev) и один
экземпляр web-сервера с [Lighhouse](https://github.com/VKCOM/lighthouse) от
VKCOM на динамически подключаемой инфраструктуре Яндекс Облака.

## Инфраструктура

Playbook использует инфраструктуру Yandex Cloud.

Инфраструктура разворачивается по средствам Terraform, который формирует статический файл инвентаря.

### Структура репозитория

| Каталог                         | Содержание                     |
| ------------------------------- | ------------------------------ |
|*./infrastructure*               | Файлы Terraform                |
|./infrastructure/modules         | Модули Terraform               |
|./infrastructure/modules/instance| Шаблон Yandex Cloud VPS        |
|./infrastructure/templates       | Шаблон файла инвентаря Ansible |
|./infrastructure/yandex          | Основной проект инфраструктуры |
|*./playbook*                     | Файлы Ansible                  |
|./playbook/site.yml              | Основной playbook проекта      |

### Управление

Управление инфраструктурой осуществляется скриптом [plan](./plan).

Инициализация Terraform:

```bash
./plan init
```

Ознакомиться с планом работ:

```bash
./plan
```

Применить план инициализации инфраструктуры:

```bash
./plan apply
```

Запустить playbook конфигурации инфраструктуры:

```bash
./plan playbook [tag]
```

Playbook поддерживает теги отдельного конфигурирования экземпляров Clickhouse, Vector или Lighhouse:

- clickhouse (`./plan playbook "clickhouse"`)
- vector (`./plan playbook "vector"`)
- lighthouse (`./plan playbook "lighthouse"`)
