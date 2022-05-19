# Домашнее задание к занятию "6.2. SQL"

## Задача 1

> Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
> в который будут складываться данные БД и бэкапы.
>
> Приведите получившуюся команду или docker-compose манифест.

```docker
version: "3.9"
services:
  postgress:
    image: "docker.io/postgres:12-alpine"
    container_name: postgres
#    ports:
#      - "5432:5432"
    volumes:
      - ./db:/var/lib/postgresql/data
      - ./backup:/backup
    environment:
      POSTGRES_PASSWORD: postgres
```

## Задача 2

> В БД из задачи 1:  
>
> - создайте пользователя test-admin-user и БД test_db
> - в БД test_db создайте таблицу orders и clients (спецификация таблиц ниже)
> - предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
> - создайте пользователя test-simple-user  
> - предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
>
> Таблица orders:
>
> - id (serial primary key)
> - наименование (string)
> - цена (integer)
>
> Таблица clients:
>
> - id (serial primary key)
> - фамилия (string)
> - страна проживания (string, index)
> - заказ (foreign key orders)

```sql
CREATE DATABASE test_db;
CREATE USER "test-admin-user";
CREATE TABLE orders (id SERIAL PRIMARY KEY, "наименование" TEXT , "цена" INTEGER);
CREATE TABLE clients (id SERIAL PRIMARY KEY, "фамилия" TEXT, "страна проживания" TEXT,  "заказ" INTEGER REFERENCES orders (id));
CREATE INDEX clients_home_ind FOR clients ("страна проживания");
GRANT ALL PRIVILEGES ON DATABASE test_db TO "test-admin-user";
CREATE USER "test-simple-user";
GRANT SELECT,INSERT,UPDATE,DELETE ON orders, clients TO "test-simple-user";
```

> Приведите:
>
> - итоговый список БД после выполнения пунктов выше,

```postgres
test_db=# \dt
          List of relations
 Schema |  Name   | Type  |  Owner   
--------+---------+-------+----------
 public | clients | table | postgres
 public | orders  | table | postgres
(2 rows)
```

> - описание таблиц (describe)

```postgres
test_db=# \d orders
                               Table "public.orders"
    Column    |  Type   | Collation | Nullable |              Default               
--------------+---------+-----------+----------+------------------------------------
 id           | integer |           | not null | nextval('orders_id_seq'::regclass)
 наименование | text    |           |          | 
 цена         | integer |           |          | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

test_db=# \d clients
                                    Table "public.clients"
      Column       |  Type   | Collation | Nullable |                 Default                  
-------------------+---------+-----------+----------+------------------------------------------
 id                | integer |           | not null | nextval('clients_id_seq'::regclass)
 фамилия           | text    |           |          | 
 страна проживания | text    |           |          | 
 заказ             | integer |           |          |                                         
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "clients_home_ind" btree ("страна проживания")
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

test_db=# 

```

> - SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

```sql
SELECT * FROM information_schema.role_table_grants where table_catalog='test_db' and table_schema='public';
```

> - список пользователей с правами над таблицами test_db

```postgres
 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | postgres         | test_db       | public       | orders     | INSERT         | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | SELECT         | YES          | YES
 postgres | postgres         | test_db       | public       | orders     | UPDATE         | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | DELETE         | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | TRUNCATE       | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | REFERENCES     | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | TRIGGER        | YES          | NO
 postgres | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | postgres         | test_db       | public       | clients    | INSERT         | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | SELECT         | YES          | YES
 postgres | postgres         | test_db       | public       | clients    | UPDATE         | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | DELETE         | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | TRUNCATE       | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | REFERENCES     | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | TRIGGER        | YES          | NO
 postgres | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
(22 rows)
```

## Задача 3

> Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:
>
> Таблица orders
>
> |Наименование|цена|
> |------------|----|
> |Шоколад| 10 |
> |Принтер| 3000 |
> |Книга| 500 |
> |Монитор| 7000|
> |Гитара| 4000|
>
> Таблица clients
>
> |ФИО|Страна проживания|
> |------------|----|
> |Иванов Иван Иванович| USA |
> |Петров Петр Петрович| Canada |
> |Иоганн Себастьян Бах| Japan |
> |Ронни Джеймс Дио| Russia|
> |Ritchie Blackmore| Russia|
>
> Используя SQL синтаксис:
>
> - вычислите количество записей для каждой таблицы
> - приведите в ответе:
>   - запросы
>   - результаты их выполнения.

```sql
INSERT INTO orders("наименование","цена") VALUES ('Шоколад',10),('Принтер',3000), ('Книга',500), ('Монитор', 7000), ('Гитара', 4000);
INSERT INTO clients("фамилия","страна проживания") VALUES ('Иванов Иван Иванович','USA'),('Петров Петр Петрович','Canada'), ('Иоганн Себастьян Бах','Japan'), ('Ронни Джеймс Дио','Russia'), ('Ritchie Blackmore','Russia');
SELECT count(*) FROM orders;
SELECT count(*) FROM clients;
```

```postgres
test_db=# SELECT count(*) FROM orders;
 count 
-------
     5
(1 row)

test_db=# SELECT count(*) FROM clients;
 count 
-------
     5
(1 row)


```

## Задача 4

> Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.
>
> Используя foreign keys свяжите записи из таблиц, согласно таблице:
>
> |ФИО|Заказ|
> |------------|----|
> |Иванов Иван Иванович| Книга |
> |Петров Петр Петрович| Монитор |
> |Иоганн Себастьян Бах| Гитара |
>
> Приведите SQL-запросы для выполнения данных операций.
>
> Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
>  
> Подсказка - используйте директиву `UPDATE`.

```sql
UPDATE clients SET "заказ"=(SELECT id FROM orders WHERE "наименование"='Книга') WHERE "фамилия"='Иванов Иван Иванович';
UPDATE clients SET "заказ"=(SELECT id FROM orders WHERE "наименование"='Монитор') WHERE "фамилия"='Петров Петр Петрович';
UPDATE clients SET "заказ"=(SELECT id FROM orders WHERE "наименование"='Гитара') WHERE "фамилия"='Иоганн Себастьян Бах';
```

```postgres
est_db=# select * from clients WHERE "заказ" IS NOT NULL;
 id |       фамилия        | страна проживания | заказ 
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(3 rows)

```

## Задача 5

> Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
> (используя директиву EXPLAIN).
>
> Приведите получившийся результат и объясните что значат полученные значения.

```postgres
test_db=# EXPLAIN ANALYZE select * from clients WHERE "заказ" IS NOT NULL;
                                             QUERY PLAN                                              
-----------------------------------------------------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72) (actual time=0.011..0.013 rows=3 loops=1)
   Filter: ("заказ" IS NOT NULL)
   Rows Removed by Filter: 2
 Planning Time: 0.043 ms
 Execution Time: 0.025 ms
(5 rows)
```

Планировщик выбрал план простого последовательного сканирования (Seq Scan). Стоимость (время в условных единицах) подготовки исходных данных - 0.00; Общая стоимость (время в условных единицах) перебора всех доступных строк - 18.10; предполагаемое количество обрабатываемых строк - 806; средний размер строки в байтах - 72.

Результат получен за один проход по всем строкам с применением фильтра. Получено три строки, две отфильтрованы. Время подготовки плана оказало почти в два раза больше, чем время исполнения.

## Задача 6

> Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).
>
> Остановите контейнер с PostgreSQL (но не удаляйте volumes).
>
> Поднимите новый пустой контейнер с PostgreSQL.
>
> Восстановите БД test_db в новом контейнере.
>
> Приведите список операций, который вы применяли для бэкапа данных и восстановления.

```bash
vagrant@server1:~$ docker exec -it postgres bash -c "pg_dumpall -U postgres > /backup/dump.sql"
vagrant@server1:~$ docker run --rm -d --name="postgres_2" -e POSTGRES_PASSWORD=postgres -v $(pwd)/backup:/backup postgres:12-alpine
85c908635e4cc105d3e43e0b923ebcc234b8510f8ca677df0bc4f8ccb1c75368
vagrant@server1:~$ docker ps -a
CONTAINER ID   IMAGE                COMMAND                  CREATED         STATUS         PORTS      NAMES
85c908635e4c   postgres:12-alpine   "docker-entrypoint.s…"   3 seconds ago   Up 2 seconds   5432/tcp   postgres_2
d7c72b85b3e6   postgres:12-alpine   "docker-entrypoint.s…"   6 hours ago     Up 6 hours     5432/tcp   postgres
vagrant@server1:~$ docker exec -it postgres_2 psql -U postgres -f /backup/dump.sql postgres
```

**Примечание**: *Я не стал останавливать контейнер `postgres`, я просто поднял рядом новый `postgres_2` без проброса на хост файлов СУБД*.
