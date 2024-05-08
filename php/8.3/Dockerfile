FROM 1maa/alpine:latest AS build

ARG PHP_VERSION=8.3.7
ARG SECP256K1_NOSTR_EXT_VERSION=v0.1.2

ENV CFLAGS="-Os -march=x86-64"
ENV LDFLAGS="-s"

WORKDIR /tmp

COPY 8.3/pubkeys.asc .

ADD https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz .
ADD https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz.asc .

RUN apk add --no-cache \
    gnupg \
    gnupg-keyboxd \
 && gpg --import pubkeys.asc \
 && gpg --verify php-${PHP_VERSION}.tar.gz.asc php-${PHP_VERSION}.tar.gz

RUN apk add --no-cache \
    # generic dependencies for compiling the source
    autoconf \
    automake \
    build-base \
    file \
    flex \
    libtool \
    re2c \
\
    upx \
\
    # dependencies for building specific extensions
    argon2-dev \
    bzip2-dev \
    curl-dev \
    db-dev \
    gd-dev \
    git \
    gmp-dev \
    gpgme-dev \
    libevent-dev \
    libffi-dev \
    libgcrypt-dev \
    libmaxminddb-dev \
    libmemcached-dev \
    libpng-dev \
    libpq-dev \
    librdkafka-dev \
    libsodium-dev \
    libssh2-dev \
    libuv-dev \
    libxml2-dev \
    libxslt-dev \
    libzip-dev \
    lmdb-dev \
    oniguruma-dev \
    openssl-dev \
    rabbitmq-c-dev \
    readline-dev \
    sqlite-dev \
    yaml-dev

RUN tar zxof php-${PHP_VERSION}.tar.gz \
 && cd ./php-${PHP_VERSION} \
 && ./configure \
    EXTENSION_DIR="/usr/lib/php" \
\
    --prefix=/usr \
    --sysconfdir=/etc/php/cli \
    --with-config-file-path=/etc/php/cli \
    --with-config-file-scan-dir=/etc/php/cli/conf.d \
\
    --enable-cli \
    --disable-fpm \
    --disable-cgi \
    --disable-phpdbg \
\
    --enable-bcmath \
    --enable-calendar \
    --enable-dba \
    --enable-exif \
    --enable-ftp \
    --enable-gd \
    --enable-mbstring \
    --enable-opcache \
    --enable-pcntl \
    --enable-shmop \
    --enable-soap \
    --enable-sockets \
\
    --with-bz2 \
    --with-curl \
    --with-db4 \
    --with-ffi \
    --with-gmp \
    --with-lmdb \
    --with-mysqli \
    --with-openssl \
    --with-password-argon2 \
    --with-pdo-mysql \
    --with-pdo-pgsql \
    --with-pear \
    --with-pgsql \
    --with-readline \
    --with-sodium \
    --with-xsl \
    --with-zip \
    --with-zlib \
 && make -j$(nproc) \
 && make install

RUN rm -rf php-${PHP_VERSION} \
 && tar zxof php-${PHP_VERSION}.tar.gz \
 && cd ./php-${PHP_VERSION} \
 && ./configure \
    EXTENSION_DIR="/usr/lib/php" \
\
    --prefix=/usr \
    --sysconfdir=/etc/php/fpm \
    --with-config-file-path=/etc/php/fpm \
    --with-config-file-scan-dir=/etc/php/fpm/conf.d \
\
    --enable-fpm \
    --disable-cli \
    --disable-cgi \
    --disable-phpdbg \
\
    --enable-bcmath \
    --enable-calendar \
    --enable-dba \
    --enable-exif \
    --enable-ftp \
    --enable-gd \
    --enable-mbstring \
    --enable-opcache \
    --enable-shmop \
    --enable-soap \
    --enable-sockets \
\
    --with-bz2 \
    --with-curl \
    --with-db4 \
    --with-ffi \
    --with-gmp \
    --with-lmdb \
    --with-mysqli \
    --with-openssl \
    --with-password-argon2 \
    --with-pdo-mysql \
    --with-pdo-pgsql \
    --with-pear \
    --with-pgsql \
    --with-sodium \
    --with-xsl \
    --with-zip \
    --with-zlib \
 && make -j$(nproc) \
 && mv sapi/fpm/php-fpm /usr/sbin/php-fpm \
\
 && sed -e 's#;phar.readonly = On#phar.readonly = Off#' \
        php.ini-production > /tmp/php.ini \
\
 && sed -e 's#@php_fpm_sysconfdir@#/etc/php/fpm#' \
        -e 's#;daemonize = yes#daemonize = no#' \
        -e 's#;error_log = log/php-fpm.log#error_log = /dev/stderr#' \
        -e 's#;log_buffering = no#log_buffering = yes#' \
        -e 's#;log_limit = 4096#log_limit = 65536#' \
        sapi/fpm/php-fpm.conf.in > /tmp/php-fpm.conf \
\
 && sed -e 's#user = @php_fpm_user@#user = root#' \
        -e 's#group = @php_fpm_group@#group = root#' \
        -e 's#listen = 127.0.0.1:9000#listen = 9000#' \
        -e 's#;clear_env = no#clear_env = no#' \
        -e 's#;catch_workers_output = yes#catch_workers_output = yes#' \
        -e 's#;decorate_workers_output = no#decorate_workers_output = no#' \
        sapi/fpm/www.conf.in > /tmp/www.conf \
\
 && upx --lzma /usr/bin/php /usr/sbin/php-fpm

RUN git clone --branch ${SECP256K1_NOSTR_EXT_VERSION} --recurse-submodules https://github.com/1ma/secp256k1-nostr-php \
 && cd secp256k1-nostr-php \
 && make secp256k1 ext \
 && make -C ext install

# Force invalidation of the build cache from here on if any
# extension has released a new version since the last build
ADD https://pecl.php.net/get/amqp .
ADD https://pecl.php.net/get/apcu .
ADD https://pecl.php.net/get/csv .
ADD https://pecl.php.net/get/ds .
ADD https://pecl.php.net/get/event .
ADD https://pecl.php.net/get/excimer .
ADD https://pecl.php.net/get/gnupg .
ADD https://pecl.php.net/get/igbinary .
ADD https://pecl.php.net/get/maxminddb .
ADD https://pecl.php.net/get/memcached .
ADD https://pecl.php.net/get/mongodb .
ADD https://pecl.php.net/get/msgpack .
ADD https://pecl.php.net/get/pcov .
ADD https://pecl.php.net/get/rdkafka .
ADD https://pecl.php.net/get/redis .
ADD https://pecl.php.net/get/runkit7 .
ADD https://pecl.php.net/get/simdjson .
ADD https://pecl.php.net/get/ssh2 .
ADD https://pecl.php.net/get/uv .
ADD https://pecl.php.net/get/vld .
ADD https://pecl.php.net/get/xdebug .
ADD https://pecl.php.net/get/yaml .
ADD https://pecl.php.net/get/yar .

RUN pecl channel-update pecl.php.net \
 && pecl install \
    amqp \
    apcu \
    csv \
    ds \
    event \
    excimer \
    gnupg \
    igbinary \
    maxminddb \
    memcached \
    mongodb \
    msgpack \
    pcov \
    rdkafka \
    redis \
    runkit7-alpha \
    simdjson \
    ssh2 \
    uv \
    vld-beta \
    xdebug \
    yaml \
#    yar \  # PHP 8.2 fix https://github.com/laruence/yar/pull/177
 && chmod 644 /usr/lib/php/*.so \
 && strip --strip-all /usr/lib/php/*.so


FROM 1maa/alpine:latest AS php

COPY etc /etc/php

COPY --from=build /tmp/php.ini      /etc/php/cli/php.ini
COPY --from=build /tmp/php.ini      /etc/php/fpm/php.ini
COPY --from=build /tmp/php-fpm.conf /etc/php/fpm/php-fpm.conf
COPY --from=build /tmp/www.conf     /etc/php/fpm/php-fpm.d/www.conf
COPY --from=build /usr/bin/php      /usr/bin/php
COPY --from=build /usr/sbin/php-fpm /usr/sbin/php-fpm
COPY --from=build /usr/lib/php/*.so /usr/lib/php/

RUN apk add --no-cache \
    argon2-libs \
    db \
    gmp \
    gpgme \
    libcurl \
    libevent \
    libffi \
    libgd \
    libmaxminddb \
    libmemcached-libs \
    libpq \
    librdkafka \
    libsodium \
    libssh2 \
    libuv \
    libxml2 \
    libxslt \
    libzip \
    lmdb \
    oniguruma \
    rabbitmq-c \
    readline \
    sqlite-libs \
    yaml \
 && rm /etc/php/mods-available/yar.ini

EXPOSE 9000

CMD ["/usr/sbin/php-fpm", "-R"]


FROM php AS build-dev

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_HOME=/opt/composer

COPY composer-pubkey.asc .

ADD https://getcomposer.org/download/latest-stable/composer.phar .
ADD https://getcomposer.org/download/latest-stable/composer.phar.asc .

RUN apk add --no-cache \
    gnupg-keyboxd \
 && gpg --import composer-pubkey.asc \
 && gpg --verify composer.phar.asc composer.phar

RUN php composer.phar global config allow-plugins.uma/composer-psysh true \
 && php composer.phar global config bin-dir /usr/local/bin \
 && php composer.phar global require \
    composer/composer \
    deployer/deployer \
    friendsofphp/php-cs-fixer \
    phing/phing \
    phpmetrics/phpmetrics \
    phpunit/phpunit \
    qossmic/deptrac-shim \
    uma/composer-psysh \
 && rm -rf ${COMPOSER_HOME}/.htaccess ${COMPOSER_HOME}/cache


FROM php AS php-dev

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_HOME=/opt/composer

COPY etc-dev /etc/php

COPY --from=build-dev ${COMPOSER_HOME} ${COMPOSER_HOME}
COPY --from=build-dev /usr/local/bin /usr/local/bin

RUN apk add --no-cache git
