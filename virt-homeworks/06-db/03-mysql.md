# Домашнее задание к занятию "6.3. MySQL"

## Задача 1

> Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Следую принципу "**всё как код**" оформил контейнер в виде Docker Compose:

```docker
version: "3.9"
services:
  mysql-8:
    image: "docker.io/mysql:8"
    container_name: mysql-8
#    user: "1000:1000"
#    ports:
#      - "3306:3306"
    volumes:
      - ./db:/var/lib/mysql
      - ./mysql.cnf:/etc/mysql/conf.d/my.cnf
    environment:
      MYSQL_DATABASE: test_db
      MYSQL_PASSWORD: ${MYSQL_PASSWORD:-user}
      MYSQL_USER: ${MYSQL_USER:-user}
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD:-root}
```

> Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и восстановитесь из него.

```bash
docker exec -i mysql-8 mysql -uuser -puser test_db < test_dump.sql 
```

> Перейдите в управляющую консоль `mysql` внутри контейнера.

```bash
 ~/w/n/d/v/0/03-mysql ❯ docker exec -it mysql-8 mysql -uuser -puser test_db
mysql: [Warning] Using a password on the command line interface can be insecure.
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 16
Server version: 8.0.29 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
```

> Используя команду `\h` получите список управляющих команд.

```shell
mysql> \h

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/

List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.
query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.
ssl_session_data_print Serializes the current SSL session data to stdout or file

For server side help, type 'help contents'

mysql> 
```

> Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

```shell
mysql> status
--------------
mysql  Ver 8.0.29 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:		16
Current database:	test_db
Current user:		user@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.29 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			40 min 7 sec

Threads: 2  Questions: 81  Slow queries: 0  Opens: 219  Flush tables: 3  Open tables: 137  Queries per second avg: 0.033
--------------

mysql> 
```

Версия MySQL: **8.0.29 MySQL Community Server - GPL**

> Подключитесь к восстановленной БД и получите список таблиц из этой БД.

```shell
mysql> use test_db;
Database changed
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)

mysql> 
```

> **Приведите в ответе** количество записей с `price` > 300.

```shell
mysql> describe orders;
+-------+--------------+------+-----+---------+----------------+
| Field | Type         | Null | Key | Default | Extra          |
+-------+--------------+------+-----+---------+----------------+
| id    | int unsigned | NO   | PRI | NULL    | auto_increment |
| title | varchar(80)  | NO   |     | NULL    |                |
| price | int          | YES  |     | NULL    |                |
+-------+--------------+------+-----+---------+----------------+
3 rows in set (0.00 sec)

mysql> SELECT count(id) FROM orders WHERE price > 300;
+-----------+
| count(id) |
+-----------+
|         1 |
+-----------+
1 row in set (0.00 sec)

mysql> 

```

> В следующих заданиях мы будем продолжать работу с данным контейнером.

## Задача 2

> Создайте пользователя test в БД c паролем test-pass, используя:
>
> - плагин авторизации mysql_native_password
> - срок истечения пароля - 180 дней
> - количество попыток авторизации - 3
> - максимальное количество запросов в час - 100
> - аттрибуты пользователя:
>   - Фамилия "Pretty"
>   - Имя "James"

```sql
CREATE USER 'test'@'%' IDENTIFIED WITH mysql_native_password BY 'test-pass'
WITH MAX_QUERIES_PER_HOUR 100
PASSWORD EXPIRE INTERVAL 180 DAY
FAILED_LOGIN_ATTEMPTS 3
ATTRIBUTE '{"last_name": "Pretty", "first_name": "James"}';
```

> Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.

```sql
GRANT SELECT ON test_db.* TO 'test'@'%';
```

> Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и **приведите в ответе к задаче**.

```sql
mysql> SELECT a.ATTRIBUTE FROM INFORMATION_SCHEMA.USER_ATTRIBUTES a WHERE a.USER='test' AND a.HOST='%';
+------------------------------------------------+
| ATTRIBUTE                                      |
+------------------------------------------------+
| {"last_name": "Pretty", "first_name": "James"} |
+------------------------------------------------+
1 row in set (0.00 sec)
```

## Задача 3

> Установите профилирование `SET profiling = 1`.
> Изучите вывод профилирования команд `SHOW PROFILES;`.

```shell
mysql> SHOW PROFILES;
+----------+------------+---------------------------------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                                         |
+----------+------------+---------------------------------------------------------------------------------------------------------------+
|        3 | 0.00109325 | show tables                                                                                                   |
|        4 | 0.00018600 | SELECT DATABASE()                                                                                             |
|        5 | 0.00063175 | show databases                                                                                                |
|        6 | 0.00131400 | show tables                                                                                                   |
|        7 | 0.00152200 | show tables                                                                                                   |
|        8 | 0.00030700 | select * from ENGINES                                                                                         |
|        9 | 0.16744900 | select * from TABLES                                                                                          |
|       10 | 0.01195650 | select * from TABLES                                                                                          |
|       11 | 0.00115825 | select * from TABLES where TABLE_SCHEMA='test_db'                                                             |
|       12 | 0.00111775 | select * from TABLES where TABLE_SCHEMA='test_db'                                                             |
|       13 | 0.00101475 | select t.TABLE_NAME, t.ENGINE, t.VERSION from information_schema.TABLES t where t.TABLE_SCHEMA='test_db'      |
|       14 | 0.00100900 | select t.TABLE_NAME, t.ENGINE from information_schema.TABLES t where t.TABLE_SCHEMA='test_db'                 |
|       15 | 0.00101450 | select t.TABLE_SCHEMA, t.TABLE_NAME, t.ENGINE from information_schema.TABLES t where t.TABLE_SCHEMA='test_db' |
|       16 | 0.00007925 | SHOW PROFILING                                                                                                |
|       17 | 0.00007200 | SHOW SHOW PROFILES                                                                                            |
+----------+------------+---------------------------------------------------------------------------------------------------------------+
15 rows in set, 1 warning (0.00 sec)
```

> Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

```sql
mysql> select t.TABLE_SCHEMA, t.TABLE_NAME, t.ENGINE from information_schema.TABLES t where t.TABLE_SCHEMA='test_db';
+--------------+------------+--------+
| TABLE_SCHEMA | TABLE_NAME | ENGINE |
+--------------+------------+--------+
| test_db      | orders     | InnoDB |
+--------------+------------+--------+
1 row in set (0.00 sec)
```

> Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
>
> - на `MyISAM`
> - на `InnoDB`

```shell
mysql> SHOW PROFILES;
+----------+------------+-------------------------------------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                                             |
+----------+------------+-------------------------------------------------------------------------------------------------------------------+
|       22 | 0.05166925 | ALTER TABLE test_db.orders ENGINE = MyISAM                                                                        |
|       23 | 0.00101275 | select t.TABLE_SCHEMA, t.TABLE_NAME, t.ENGINE from information_schema.TABLES t where t.TABLE_SCHEMA='test_db'     |
|       24 | 0.00027375 | select * from test_db.orders                                                                                      |
|       25 | 0.00655650 | update test_db.orders set price='321' where id=5                                                                  |
|       26 | 0.05946125 | ALTER TABLE test_db.orders ENGINE = InnoDB                                                                        |
|       27 | 0.00031975 | select * from test_db.orders                                                                                      |
|       28 | 0.01135500 | update test_db.orders set price='123' where id=5                                                                  |
+----------+------------+-------------------------------------------------------------------------------------------------------------------+
15 rows in set, 1 warning (0.00 sec)
```

## Задача 4 

> Изучите файл `my.cnf` в директории /etc/mysql.
>
> Измените его согласно ТЗ (движок InnoDB):
>
> - Скорость IO важнее сохранности данных
> - Нужна компрессия таблиц для экономии места на диске
> - Размер буффера с незакомиченными транзакциями 1 Мб
> - Буффер кеширования 30% от ОЗУ
> - Размер файла логов операций 100 Мб
>
> Приведите в ответе измененный файл `my.cnf`.

Подготовлен файл mysql.cnf и подключен в контейнер по пути `/etc/mysql/conf.d/my.cnf`

```ini
[mysqld]
# default_authentication_plugin=mysql_native_password

# Лог операций сохраняется и фиксируется раз в секунду.
# В случае сбоя весьма вероятна потеря данных.
innodb_flush_log_at_trx_commit = 0

# Данные таблиц размещаются в отдельных файлах,
# что позволяет использовать сжатие blob/text полей.
innodb_file_per_table

# Размер буффера с незакомиченными транзакциями 1 Мб
innodb_log_buffer_size=1M

# Буффер кеширования 30% от ОЗУ
innodb_buffer_pool_size=2G

# Размер файла логов операций 100 Мб
innodb_log_file_size=100M
```

Подтверждение установленных параметров:

```sql
mysql> show variables where Variable_name in ('innodb_flush_log_at_trx_commit','innodb_file_per_table','innodb_log_buffer_size','innodb_buffer_pool_size','innodb_log_file_size');
+--------------------------------+------------+
| Variable_name                  | Value      |
+--------------------------------+------------+
| innodb_buffer_pool_size        | 2147483648 |
| innodb_file_per_table          | ON         |
| innodb_flush_log_at_trx_commit | 0          |
| innodb_log_buffer_size         | 1048576    |
| innodb_log_file_size           | 104857600  |
+--------------------------------+------------+
5 rows in set (0.00 sec)
```
