# mysql
This Dockerfile extends the [official MySQL 5.7](https://hub.docker.com/_/mysql/) image and enforces the
character set to be UTF-8 for all its databases. It is primarily meant to support a Symfony application. See the database
configuration section in the [Symfony docs](http://symfony.com/doc/current/book/doctrine.html#configuring-the-database) to understand
why it does what it does.

If you are indeed builing a Symfony application  remember to add a ```server_version``` key inside the DBAL configuration
block of your ```app/config/config.yml``` file, otherwise [very bad things may happen](https://github.com/symfony/symfony/issues/17727).

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
