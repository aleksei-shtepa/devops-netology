# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

> В этом задании вы потренируетесь в:
>
> - установке elasticsearch
> - первоначальном конфигурировании elastcisearch
> - запуске elasticsearch в docker
>
> Используя докер образ [elasticsearch:7](https://hub.docker.com/_/elasticsearch) как базовый:
>
> - составьте Dockerfile-манифест для elasticsearch
> - соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
> - запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины
>
> Требования к `elasticsearch.yml`:
>
> - данные `path` должны сохраняться в `/var/lib`
> - имя ноды должно быть `netology_test`
>
> В ответе приведите:
>
> - текст Dockerfile манифеста
> - ссылку на образ в репозитории dockerhub
> - ответ `elasticsearch` на запрос пути `/` в json виде
>
> Подсказки:
>
> - при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
> - при некоторых проблемах вам поможет docker директива ulimit
> - elasticsearch в логах обычно описывает проблему и пути ее решения
> - обратите внимание на настройки безопасности такие как `xpack.security.enabled` 
> - если докер образ не запускается и падает с ошибкой 137 в этом случае может помочь настройка `-e ES_HEAP_SIZE`
> - при настройке `path` возможно потребуется настройка прав доступа на директорию

Я подготовил файлы настроек для [Java virtual machine](05-elasicsearch/jvm.options) и [ElasticSearch](05-elasicsearch/elasticsearch.yml).

elasticsearch.yml:

```yaml
cluster.name: shtepa-cluster
network.host: 0.0.0.0

# Имя ноды по умолчанию.
# (Переопределяется через переменные окружения)
node.name: netology_test

# Расположение по умолчанию для данных, логов и снимков.
# (Переопределяется через переменные окружения)
path.data: /var/lib/elastic-7
path.logs: /var/log/elastic-7
path.repo: /usr/share/elasticsearch/snapshots
```

По условию данные должны быть размещены в `/var/lib`. Засорять этот стандартный каталог плохая идея, поэтому данные сохраняются в `/var/lib/elastic-7`.

Подготовил файлы манифестов [Dockerfile](./05-elasicsearch/Dockerfile) и [docker-compose.yml](./05-elasicsearch/docker-compose.yml).

Манифест образа:

```dockerfile
FROM elasticsearch:7.17.4

COPY ./elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml
COPY ./jvm.options /usr/share/elasticsearch/config/jvm.options.d/jvm.options

RUN mkdir /var/lib/elastic-7 && chown elasticsearch /var/lib/elastic-7 &&\
    mkdir /var/log/elastic-7 && chown elasticsearch /var/log/elastic-7 &&\
    mkdir /usr/share/elasticsearch/snapshots && chown elasticsearch /usr/share/elasticsearch/snapshots
```

Для запуска сервиса подготовлен `docker-compose.yml`:

```yaml
version: '3.2'
services:
  elastic:
    image: docker.io/alekseishtepa/elastic:7.17.4
    build: .
    container_name: elastic-7
    environment:
      - discovery.type=single-node
      - node.name=netology_test
  #  - "ES_JAVA_OPTS=-Xms1g -Xmx1g"
    ports:
      - 9200:9200
    volumes:
      - "_data:/var/lib/elastic-7"
      - "_logs:/var/log/elastic-7"
      - "_snapshots:/usr/share/elasticsearch/snapshots"
    networks:
      - elastic

networks:
  elastic:
```

Собран образ и отправлен в репозиторий [https://hub.docker.com/r/alekseishtepa/elastic](https://hub.docker.com/r/alekseishtepa/elastic):

```shell
~/w/n/d/v/0/05-elasicsearch ❯ podman build -t docker.io/alekseishtepa/elastic:7.17.4 .
...
~/w/n/d/v/0/05-elasicsearch ❯ podman login docker.io
...
~/w/n/d/v/0/05-elasicsearch ❯ podman push docker.io/alekseishtepa/elastic:7.17.4
```

Получение данных от сервиса:

```shell
~/w/n/d/v/0/05-elasicsearch ❯ curl 127.1:9200
{
  "name" : "netology_test",
  "cluster_name" : "shtepa-cluster",
  "cluster_uuid" : "T9bcai7VTHetSiCerII_lw",
  "version" : {
    "number" : "7.17.4",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "79878662c54c886ae89206c685d9f1051a9d6411",
    "build_date" : "2022-05-18T18:04:20.964345128Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

## Задача 2

> В этом задании вы научитесь:
>
> - создавать и удалять индексы
> - изучать состояние кластера
> - обосновывать причину деградации доступности данных
>
> Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
> и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:
>
> | Имя | Количество реплик | Количество шард |
> |-----|-------------------|-----------------|
> | ind-1| 0 | 1 |
> | ind-2 | 1 | 2 |
> | ind-3 | 2 | 4 |
>
> Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.
>
> Получите состояние кластера `elasticsearch`, используя API.
>
> Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?
>
> Удалите все индексы.
>
> **Важно**
>
> При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
> иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

Добавление индексов через REST API ElasticSearch:

```shell
 ~/w/n/d/v/0/05-elasicsearch ❯ curl -H 'Content-Type: application/json' -X PUT -d '{"settings": {"number_of_shards": 1,"number_of_replicas": 0}}' 127.1:9200/ind-1
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"}

 ~/w/n/d/v/0/05-elasicsearch ❯ curl -H 'Content-Type: application/json' -X PUT -d '{"settings": {"number_of_shards": 2,"number_of_replicas": 1}}' 127.1:9200/ind-2
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-2"}

 ~/w/n/d/v/0/05-elasicsearch ❯ curl -H 'Content-Type: application/json' -X PUT -d '{"settings": {"number_of_shards": 4,"number_of_replicas": 2}}' 127.1:9200/ind-3
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-3"}
```

Получение статуса индексов:

```shell
 ~/w/n/d/v/0/05-elasicsearch ❯ curl 127.1:9200/_cat/indices
green  open .geoip_databases ro8h4Vj7T3Odtn3pO--lFg 1 0 41 38 38.8mb 38.8mb
green  open ind-1            VbZeT_zjRqyLcc3dOhDrAQ 1 0  0  0   226b   226b
yellow open ind-3            KV-ivS1oQQmpKTv-d6nHZg 4 2  0  0   904b   904b
yellow open ind-2            cIYR7deqSpeTK7fsoI22-g 2 1  0  0   452b   452b
```

Получение статуса кластера:

```bash
 ~/w/n/d/v/0/05-elasicsearch ❯ curl "127.1:9200/_cluster/health?pretty=true"
 {
    "cluster_name": "shtepa-cluster",
    "status": "yellow",
    "timed_out": false,
    "number_of_nodes": 1,
    "number_of_data_nodes": 1,
    "active_primary_shards": 10,
    "active_shards": 10,
    "relocating_shards": 0,
    "initializing_shards": 0,
    "unassigned_shards": 10,
    "delayed_unassigned_shards": 0,
    "number_of_pending_tasks": 0,
    "number_of_in_flight_fetch": 0,
    "task_max_waiting_in_queue_millis": 0,
    "active_shards_percent_as_number": 50
}
```

Так как у части индексов количество реплик превышает количество имеющихся узлов, то мы получаем неназначенные шарды (**unassigned_shards**). Ненулевое значение этого параметра "красит" состояние кластера в **yellow**. По той же причине статус индексов `ind-2` и `ind-3` тоже **yellow**.

Удаление индексов:

```shell
~/w/n/d/v/0/05-elasicsearch ❯ curl -X DELETE "127.1:9200/ind-1"
{"acknowledged":true}

~/w/n/d/v/0/05-elasicsearch ❯ curl -X DELETE "127.1:9200/ind-2"
{"acknowledged":true}

~/w/n/d/v/0/05-elasicsearch ❯ curl -X DELETE "127.1:9200/ind-3"
{"acknowledged":true}

~/w/n/d/v/0/05-elasicsearch ❯ curl "127.1:9200/_cat/indices?v"
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases ro8h4Vj7T3Odtn3pO--lFg   1   0         41           38     38.8mb         38.8mb
```

## Задача 3

> В данном задании вы научитесь:
>
> - создавать бэкапы данных
> - восстанавливать индексы из бэкапов
>
> Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.
> 
> Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
> данную директорию как `snapshot repository` c именем `netology_backup`.
> 
> **Приведите в ответе** запрос API и результат вызова API для создания репозитория.

```shell
 ~/w/n/d/v/0/05-elasicsearch ❯ curl -X PUT -H 'Content-Type: application/json' -d '{"type":"fs","settings":{"location":"netology_backup"}}' "127.1:9200/_snapshot/netology_backup"
{"acknowledged":true}
```

> Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

```shell
~/w/n/d/v/0/05-elasicsearch ❯ curl -X PUT -H 'Content-Type: application/json' -d '{"settings": {"number_of_shards": 1,"number_of_replicas": 0}}' "127.1:9200/test?pretty=true"
{
    "acknowledged": true,
    "shards_acknowledged": true,
    "index": "test"
}

 ~/w/n/d/v/0/05-elasicsearch ❯ curl "127.1:9200/_cat/indices?v"
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases ro8h4Vj7T3Odtn3pO--lFg   1   0         41           38     38.8mb         38.8mb
green  open   test
```

> [Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
> состояния кластера `elasticsearch`.

```shell
 ~/w/n/d/v/0/05-elasicsearch ❯ curl -X PUT "127.1:9200/_snapshot/netology_backup/new_test2?wait_for_completion&pretty"
{
  "snapshot" : {
    "snapshot" : "new_test2",
    "uuid" : "yTpLH1vWRKOf9cwYvejVog",
    "repository" : "netology_backup",
    "version_id" : 7170499,
    "version" : "7.17.4",
    "indices" : [
      "test",
      ".geoip_databases",
      ".ds-ilm-history-5-2022.06.09-000001",
      ".ds-.logs-deprecation.elasticsearch-default-2022.06.09-000001"
    ],
    "data_streams" : [
      "ilm-history-5",
      ".logs-deprecation.elasticsearch-default"
    ],
    "include_global_state" : true,
    "state" : "SUCCESS",
    "start_time" : "2022-06-10T12:11:19.811Z",
    "start_time_in_millis" : 1654863079811,
    "end_time" : "2022-06-10T12:11:19.811Z",
    "end_time_in_millis" : 1654863079811,
    "duration_in_millis" : 0,
    "failures" : [ ],
    "shards" : {
      "total" : 4,
      "failed" : 0,
      "successful" : 4
    },
    "feature_states" : [
      {
        "feature_name" : "geoip",
        "indices" : [
          ".geoip_databases"
        ]
      }
    ]
  }
}
```

> **Приведите в ответе** список файлов в директории со `snapshot`ами.

Файлы проброшенные из контейнера на хост-машину:

```shell
 ~/w/n/d/v/0/05-elasicsearch ❯ l ~/.local/share/containers/storage/volumes/05-elasicsearch__snapshots/_data/netology_backup/
итого 224K
drwxrwxr-x 1 100999 shtepa  176 июн 10 14:31 indices/
-rw-rw-r-- 1 100999 shtepa 4,0K июн 10 15:11 index-5
-rw-rw-r-- 1 100999 shtepa    8 июн 10 15:11 index.latest
-rw-rw-r-- 1 100999 shtepa  29K июн 10 14:32 meta-9qIwGCUxSNK35fdDmwlFVA.dat
-rw-rw-r-- 1 100999 shtepa  29K июн 10 14:50 meta-E1KPQeF1SjyXls03T1grAQ.dat
-rw-rw-r-- 1 100999 shtepa  29K июн 10 14:31 meta-LqiKnyLSSw2WijvN8sYnuQ.dat
-rw-rw-r-- 1 100999 shtepa  29K июн 10 15:08 meta-v6qyUINBTa2dGoaL7quLAw.dat
-rw-rw-r-- 1 100999 shtepa  29K июн 10 14:51 meta-yoTPpifCST621em3rY74kg.dat
-rw-rw-r-- 1 100999 shtepa  29K июн 10 15:11 meta-yTpLH1vWRKOf9cwYvejVog.dat
-rw-rw-r-- 1 100999 shtepa  705 июн 10 14:32 snap-9qIwGCUxSNK35fdDmwlFVA.dat
-rw-rw-r-- 1 100999 shtepa  703 июн 10 14:50 snap-E1KPQeF1SjyXls03T1grAQ.dat
-rw-rw-r-- 1 100999 shtepa  721 июн 10 14:31 snap-LqiKnyLSSw2WijvN8sYnuQ.dat
-rw-rw-r-- 1 100999 shtepa  707 июн 10 15:08 snap-v6qyUINBTa2dGoaL7quLAw.dat
-rw-rw-r-- 1 100999 shtepa  702 июн 10 14:51 snap-yoTPpifCST621em3rY74kg.dat
-rw-rw-r-- 1 100999 shtepa  708 июн 10 15:11 snap-yTpLH1vWRKOf9cwYvejVog.dat
```

Эти же файлы внутри контейнера:

```shell
 ~/w/n/d/v/0/05-elasicsearch ❯ podman exec -it elastic-7 bash
root@a6496cf0adad:/usr/share/elasticsearch# ls -l snapshots/netology_backup/
total 224
-rw-rw-r-- 1 elasticsearch root  4089 Jun 10 12:11 index-5
-rw-rw-r-- 1 elasticsearch root     8 Jun 10 12:11 index.latest
drwxrwxr-x 1 elasticsearch root   176 Jun 10 11:31 indices
-rw-rw-r-- 1 elasticsearch root 29284 Jun 10 11:32 meta-9qIwGCUxSNK35fdDmwlFVA.dat
-rw-rw-r-- 1 elasticsearch root 29260 Jun 10 11:50 meta-E1KPQeF1SjyXls03T1grAQ.dat
-rw-rw-r-- 1 elasticsearch root 29284 Jun 10 11:31 meta-LqiKnyLSSw2WijvN8sYnuQ.dat
-rw-rw-r-- 1 elasticsearch root 29260 Jun 10 12:08 meta-v6qyUINBTa2dGoaL7quLAw.dat
-rw-rw-r-- 1 elasticsearch root 29260 Jun 10 12:11 meta-yTpLH1vWRKOf9cwYvejVog.dat
-rw-rw-r-- 1 elasticsearch root 29260 Jun 10 11:51 meta-yoTPpifCST621em3rY74kg.dat
-rw-rw-r-- 1 elasticsearch root   705 Jun 10 11:32 snap-9qIwGCUxSNK35fdDmwlFVA.dat
-rw-rw-r-- 1 elasticsearch root   703 Jun 10 11:50 snap-E1KPQeF1SjyXls03T1grAQ.dat
-rw-rw-r-- 1 elasticsearch root   721 Jun 10 11:31 snap-LqiKnyLSSw2WijvN8sYnuQ.dat
-rw-rw-r-- 1 elasticsearch root   707 Jun 10 12:08 snap-v6qyUINBTa2dGoaL7quLAw.dat
-rw-rw-r-- 1 elasticsearch root   708 Jun 10 12:11 snap-yTpLH1vWRKOf9cwYvejVog.dat
-rw-rw-r-- 1 elasticsearch root   702 Jun 10 11:51 snap-yoTPpifCST621em3rY74kg.dat
root@a6496cf0adad:/usr/share/elasticsearch# 
```

> Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```shell
 ~/w/n/d/v/0/05-elasicsearch ❯ curl -X DELETE "127.1:9200/test"
{"acknowledged":true}

 ~/w/n/d/v/0/05-elasicsearch ❯ curl -X PUT -H 'Content-Type: application/json' -d '{"settings": {"number_of_shards": 1,"number_of_replicas": 0}}' "127.1:9200/test2"
{"acknowledged":true,"shards_acknowledged":true,"index":"test2"}

 ~/w/n/d/v/0/05-elasicsearch ❯ curl -X GET "127.1:9200/_cat/indices?v"
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases ro8h4Vj7T3Odtn3pO--lFg   1   0         41           38     38.8mb         38.8mb
green  open   test2            PNgFJ3LHSc-bDc4kkXKldA   1   0          0            0       226b           226b
```

> [Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
> кластера `elasticsearch` из `snapshot`, созданного ранее. 
>
> **Приведите в ответе** запрос к API восстановления и итоговый список индексов.
>
> Подсказки:
>
> - возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

```shell
 ~/w/n/d/v/0/05-elasicsearch ❯ curl -X POST -H 'Content-Type: application/json' -d '{"indices":"test"}' "127.1:9200/_snapshot/netology_backup/new_test2/_restore?pretty"
{
  "accepted" : true
}

 ~/w/n/d/v/0/05-elasicsearch ❯ curl -X GET "127.1:9200/_cat/indices?v"
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases ro8h4Vj7T3Odtn3pO--lFg   1   0         41           38     38.8mb         38.8mb
green  open   test2            PNgFJ3LHSc-bDc4kkXKldA   1   0          0            0       226b           226b
green  open   test             N35kSBEsR1GjHv18fvaJ_w   1   0          0            0       226b           226b
 ~/w/n/d/v/0/05-elasicsearch ❯ 
```
