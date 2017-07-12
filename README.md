# 1ma's Dockerfile repository

https://hub.docker.com/u/1maa/


### Index

| Image Name          | Summary                                                                             |
|---------------------|-------------------------------------------------------------------------------------|
| 1maa/alpine         | Foundation for most other images. Overrides the entrypoint with tini.               |
| 1maa/beanstalkd     | Beanstalkd server from APK repository.                                              |
| 1maa/debian         | Old base image, no longer used.                                                     |
| 1maa/docker-compose | Docker-compose binary as an image. Used for building Docker based CI environments.  |
| 1maa/mysql          | Extension of the official MySQL tweaked to play nice with the Doctrine ORM.         |
| 1maa/nodetools      | NodeJS, NPM, Bower, Grunt, Gulp and LESS.                                           |
| 1maa/php-cli        | PHP cli with a ton of common PHP extensions.                                        |
| 1maa/php-apa        | Apache with mod_php. Built on top of 1maa/php-cli.                                  |
| 1maa/php-fpm        | PHP FastCGI Process Manager (FPM) to pair with nginx. Built on top of 1maa/php-cli. |
| 1maa/php-sdk        | Building environment for any PECL extensions.                                       |
| 1maa/selfsig        | Small utility wrapping LibreSSL for generating self-signed dev certificates.        |
| 1maa/postgres       | PostgreSQL server from APK repository.  Does not include the database cluster.      |
| 1maa/postgres-dev   | PostgreSQL development server with a 'docker:docker' superuser in the cluster.      |
