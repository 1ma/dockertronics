FROM php:7.3-alpine

ENV COMPOSER_ALLOW_SUPERUSER=1

WORKDIR /tmp

COPY composer-pubkey.asc .

ADD https://github.com/perftools/xhgui/archive/master.tar.gz .
ADD https://getcomposer.org/download/latest-stable/composer.phar .
ADD https://getcomposer.org/download/latest-stable/composer.phar.asc .

RUN apk add --no-cache gnupg \
 && gpg --import composer-pubkey.asc \
 && gpg --verify composer.phar.asc composer.phar

RUN apk add --no-cache \
    autoconf \
    build-base \
 && pecl install mongodb-1.16.2 \
 && docker-php-ext-enable mongodb

RUN tar zxf master.tar.gz \
 && cd xhgui-0.21.x \
 && php /tmp/composer.phar config --unset platform.ext-mongodb \
 && php /tmp/composer.phar update \
 && php /tmp/composer.phar require alcaeus/mongo-php-adapter \
 && php /tmp/composer.phar install --no-dev -a


FROM php:7.3-apache

COPY          vhost.conf        /etc/apache2/sites-available/000-default.conf
COPY --from=0 /tmp/xhgui-0.21.x /var/www/xhgui

RUN cp ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini \
 && apt-get update \
 && apt-get install -y \
    libpq-dev \
 && rm -rf /var/lib/apt/lists/* \
 && chmod -R 777 /var/www/xhgui/cache \
 && docker-php-ext-install -j$(nproc) \
    pdo_mysql \
    pdo_pgsql \
 && pecl install mongodb-1.16.2 \
 && docker-php-ext-enable mongodb \
 && a2enmod rewrite

WORKDIR /var/www/xhgui

EXPOSE 80
