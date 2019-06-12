FROM 1maa/php-dev:7.3

WORKDIR /tmp

ADD https://github.com/perftools/xhgui/archive/master.tar.gz .

RUN tar zxf master.tar.gz \
 && cd xhgui-master \
 && composer require alcaeus/mongo-php-adapter \
 && composer install --no-dev -a


FROM php:7.3-apache

COPY          vhost.conf        /etc/apache2/sites-available/000-default.conf
COPY --from=0 /tmp/xhgui-master /var/www/xhgui

RUN cp ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini \
 && apt-get update \
 && apt-get install -y \
    libpq-dev \
 && rm -rf /var/lib/apt/lists/* \
 && chmod -R 777 /var/www/xhgui/cache \
 && docker-php-ext-install -j$(nproc) \
    pdo_mysql \
    pdo_pgsql \
 && pecl install \
    mongodb \
 && docker-php-ext-enable mongodb \
 && a2enmod rewrite

WORKDIR /var/www/xhgui

EXPOSE 80
