# mysql
This Dockerfile extends the [official MySQL 5.7](https://hub.docker.com/_/mysql/) image and enforces the
character set to be UTF-8 for all its databases. It is primarily meant to support a Symfony application. See the database
configuration section in the [Symfony docs](http://symfony.com/doc/current/book/doctrine.html#configuring-the-database) to understand
why it does what it does.

If you are indeed builing a Symfony application  remember to add a ```server_version``` key inside the DBAL configuration
block of your ```app/config/config.yml``` file, otherwise [very bad things may happen](https://github.com/symfony/symfony/issues/17727).

It also enables the general log in `/var/lib/mysql/general.log` and the slow query log in `/var/lib/mysql/slow.log` to ease up DB debugging.

```yml
# app/config/config.yml
doctrine:
    dbal:
        driver:   pdo_mysql
        host:     '%database_host%'
        dbname:   '%database_name%'
        user:     '%database_user%'
        password: '%database_password%'
        server_version: '5.7'
```


## Details

### Default `mysql:5.7` image

```
$ docker exec -it mysql57 mysql -u root -proot

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.7.23 MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SHOW VARIABLES LIKE "%char%";
+--------------------------+----------------------------+
| Variable_name            | Value                      |
+--------------------------+----------------------------+
| character_set_client     | latin1                     |
| character_set_connection | latin1                     |
| character_set_database   | latin1                     |
| character_set_filesystem | binary                     |
| character_set_results    | latin1                     |
| character_set_server     | latin1                     |
| character_set_system     | utf8                       |
| character_sets_dir       | /usr/share/mysql/charsets/ |
+--------------------------+----------------------------+
8 rows in set (0.00 sec)

mysql> SHOW VARIABLES LIKE "%colla%";
+----------------------+-------------------+
| Variable_name        | Value             |
+----------------------+-------------------+
| collation_connection | latin1_swedish_ci |
| collation_database   | latin1_swedish_ci |
| collation_server     | latin1_swedish_ci |
+----------------------+-------------------+
3 rows in set (0.00 sec)

mysql> SHOW VARIABLES LIKE "%slow_q%";
+---------------------+--------------------------------------+
| Variable_name       | Value                                |
+---------------------+--------------------------------------+
| slow_query_log      | OFF                                  |
| slow_query_log_file | /var/lib/mysql/8b1f471b67a4-slow.log |
+---------------------+--------------------------------------+
2 rows in set (0.01 sec)

mysql> SHOW VARIABLES LIKE "%general_log%";
+------------------+---------------------------------+
| Variable_name    | Value                           |
+------------------+---------------------------------+
| general_log      | OFF                             |
| general_log_file | /var/lib/mysql/8b1f471b67a4.log |
+------------------+---------------------------------+
2 rows in set (0.00 sec)
```

### `1maa/mysql:5.7` image

```
$ docker exec -it 1maa_mysql57 mysql -u root -proot

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.7.23-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SHOW VARIABLES LIKE "%char%";
+--------------------------+----------------------------+
| Variable_name            | Value                      |
+--------------------------+----------------------------+
| character_set_client     | utf8mb4                    |
| character_set_connection | utf8mb4                    |
| character_set_database   | utf8mb4                    |
| character_set_filesystem | binary                     |
| character_set_results    | utf8mb4                    |
| character_set_server     | utf8mb4                    |
| character_set_system     | utf8                       |
| character_sets_dir       | /usr/share/mysql/charsets/ |
+--------------------------+----------------------------+
8 rows in set (0.01 sec)

mysql> SHOW VARIABLES LIKE "%colla%";
+----------------------+--------------------+
| Variable_name        | Value              |
+----------------------+--------------------+
| collation_connection | utf8mb4_general_ci |
| collation_database   | utf8mb4_unicode_ci |
| collation_server     | utf8mb4_unicode_ci |
+----------------------+--------------------+
3 rows in set (0.00 sec)

mysql> SHOW VARIABLES LIKE "%slow_q%";
+---------------------+-------------------------+
| Variable_name       | Value                   |
+---------------------+-------------------------+
| slow_query_log      | ON                      |
| slow_query_log_file | /var/lib/mysql/slow.log |
+---------------------+-------------------------+
2 rows in set (0.00 sec)

mysql> SHOW VARIABLES LIKE "%general_log%";
+------------------+----------------------------+
| Variable_name    | Value                      |
+------------------+----------------------------+
| general_log      | ON                         |
| general_log_file | /var/lib/mysql/general.log |
+------------------+----------------------------+
2 rows in set (0.00 sec)
```
