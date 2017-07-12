# 1ma's Dockerfile repository

https://hub.docker.com/u/1maa/


### Index

| Image               | Tags          | Summary                                                                                   |
|---------------------|---------------|-------------------------------------------------------------------------------------------|
| 1maa/alpine         | 3.4, edge     | Foundation for most other images. Overrides the entrypoint with tini.                     |
| 1maa/beanstalkd     | 1.10          | Beanstalkd server from APK repository.                                                    |
| 1maa/debian         | jessie        | Old base image, no longer used.                                                           |
| 1maa/docker-compose | latest        | Docker-compose binary as an image. Used for building Docker based CI environments.        |
| 1maa/mysql          | 5.7           | Extension of the official MySQL tweaked to play nice with the Doctrine ORM.               |
| 1maa/nodetools      | 4.x           | NodeJS, NPM, Bower, Grunt, Gulp and LESS.                                                 |
| 1maa/php-cli        | 5.6, 7.0, 7.1 | PHP cli with a ton of common PHP extensions.                                              |
| 1maa/php-apa        | 5.6, 7.0, 7.1 | Apache with mod_php. Built on top of 1maa/php-cli.                                        |
| 1maa/php-fpm        | 5.6, 7.0, 7.1 | PHP FastCGI Process Manager (FPM) to pair with nginx. Built on top of 1maa/php-cli.       |
| 1maa/php-sdk        | 5.6, 7.0, 7.1 | Building environment for any PECL extensions.                                             |
| 1maa/selfsig        | latest        | Small utility wrapping LibreSSL for generating self-signed dev certificates.              |
| 1maa/postgres       | 9.5           | PostgreSQL server from APK repository.  Does not include the database cluster.            |
| 1maa/postgres-dev   | 9.5           | PostgreSQL development server with a 'docker:docker' superuser in the cluster.            |
