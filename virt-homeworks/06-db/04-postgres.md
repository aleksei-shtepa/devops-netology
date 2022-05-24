# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

> Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
>
> Подключитесь к БД PostgreSQL используя `psql`.
>
> Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

Следуя принципу "всё как код" сервис оформлен в виде Docker Compose файла:

```docker
version: "3.9"
services:
  postgress:
    image: "docker.io/postgres:13-alpine"
    container_name: postgres_13a
#    ports:
#      - "5432:5432"
    volumes:
      - ./db:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-postgres}
```

Подключение к СУБД и вывод части справки по командам:

```shell
 ~/w/n/d/v/0/04-postgres ❯ docker exec -it postgres_13a psql -U postgres
psql (13.7)
Type "help" for help.

postgres=# \?
General
  \copyright             show PostgreSQL usage and distribution terms
  \crosstabview [COLUMNS] execute query and display results in crosstab
  \errverbose            show most recent error message at maximum verbosity
  \g [(OPTIONS)] [FILE]  execute query (and send results to file or |pipe);
                         \g with no arguments is equivalent to a semicolon
  \gdesc                 describe result of query, without executing it
...
```

> **Найдите и приведите** управляющие команды для:
>
> - вывода списка БД

```postgres
  \l[+]   [PATTERN]      list databases
```

> - подключения к БД

```postgres
  \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")
```

> - вывода списка таблиц

```postgres
  \d[S+]                 list tables, views, and sequences
  \dt[S+] [PATTERN]      list tables
```

> - вывода описания содержимого таблиц

```postgres
  \d[S+]  NAME           describe table, view, sequence, or index
```

> - выхода из psql

```postgres
  \q                     quit psql
```

## Задача 2

> Используя `psql` создайте БД `test_database`.

```bash
 ~/w/n/d/v/0/04-postgres ❯ echo "CREATE DATABASE test_database;" | docker exec -i postgres_13a psql -U postgres
CREATE DATABASE
```

> Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).
>
> Восстановите бэкап БД в `test_database`.

```bash
 ~/w/n/d/v/0/04-postgres ❯ cat test_dump.sql | docker exec -i postgres_13a psql -U postgres test_database
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE
```

> Перейдите в управляющую консоль `psql` внутри контейнера.
>
> Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

```bash
 ~/w/n/d/v/0/04-postgres ❯ docker exec -it postgres_13a psql -U postgres
psql (13.7)
Type "help" for help.

postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=# \d orders
                                   Table "public.orders"
 Column |         Type          | Collation | Nullable |              Default               
--------+-----------------------+-----------+----------+------------------------------------
 id     | integer               |           | not null | nextval('orders_id_seq'::regclass)
 title  | character varying(80) |           | not null | 
 price  | integer               |           |          | 0
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)

test_database=# ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
test_database=# 
```

> Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
> с наибольшим средним значением размера элементов в байтах.
>
> **Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

```sql
test_database=# SELECT s.attname FROM pg_catalog.pg_stats s
test_database-# WHERE s.avg_width = (
test_database(# select MAX(s.avg_width) from pg_catalog.pg_stats s where s.tablename='orders')
test_database-# AND
test_database-# s.tablename='orders';
 attname 
---------
 title
(1 row)
```

## Задача 3

> Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
> поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
> провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).
>
> Предложите SQL-транзакцию для проведения данной операции.

```sql
CREATE TABLE orders_1(
    CHECK ( price > 499 )
) INHERITS (orders);

CREATE TABLE orders_2(
    CHECK ( price <= 499 )
) INHERITS (orders);

CREATE RULE new_insert_to_1 AS ON INSERT TO orders
WHERE (price > 499)
DO INSTEAD INSERT INTO orders_1 VALUES (NEW.*);

CREATE RULE new_insert_to_2 AS ON INSERT TO orders
WHERE (price <= 499)
DO INSTEAD INSERT INTO orders_2 VALUES (NEW.*);
```

Все новые данные будут раскладываться по партициям, но уже накопленные продолжат храниться в основной таблице.

Можно принудительно перенести уже накопленные данные по партициям:

```sql
WITH moved_rows_1 AS (
    DELETE FROM orders WHERE price > 499 RETURNING *
) INSERT INTO orders_1 SELECT * FROM moved_rows_1;

WITH moved_rows_2 AS (
    DELETE FROM orders WHERE price  <= 499 RETURNING *
) INSERT INTO orders_2 SELECT * FROM moved_rows_2;
```

> Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Я полагаю, что именно при проектировании и нужно было предусмотреть шардирование таблицы - не пришлось бы переносить уже накопленные данные по наследующим таблицам (партициям).

## Задача 4

> Используя утилиту `pg_dump` создайте бекап БД `test_database`.

```bash
 ~/w/n/d/v/0/04-postgres ❯ docker exec -it postgres_13a bash -c "pg_dump -U postgres test_database" > test_database.sql.dump
```

> Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

Так как после шардинга в наследованных таблицах не переносятся индексы и уникальность полей, то для них это нужно делать вручную.

В backup-файл нужно добавить строки:

```sql
--
-- Add unique column `title`
--
ALTER TABLE orders ADD CONSTRAINT orders_title_unique UNIQUE(title);
ALTER TABLE orders_1 ADD CONSTRAINT orders_1_title_unique UNIQUE(title);
ALTER TABLE orders_2 ADD CONSTRAINT orders_2_title_unique UNIQUE(title);
```
