FROM php:7.3-alpine

ENV COMPOSER_VERSION=2.1.6
ENV COMPOSER_ALLOW_SUPERUSER=1

WORKDIR /tmp

COPY composer-pubkey.asc .

ADD https://github.com/perftools/xhgui/archive/master.tar.gz .
ADD https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar .
ADD https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar.asc .

RUN apk add --no-cache gnupg \
 && gpg --import composer-pubkey.asc \
 && gpg --verify composer.phar.asc composer.phar

RUN tar zxf master.tar.gz \
 && cd xhgui-master \
 && php /tmp/composer.phar update \
 && php /tmp/composer.phar require alcaeus/mongo-php-adapter \
 && php /tmp/composer.phar install --no-dev -a


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
