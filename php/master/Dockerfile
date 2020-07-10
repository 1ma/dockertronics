FROM 1maa/postgres:12-src AS postgres

FROM 1maa/alpine:3.12 AS build

ENV PHP_VERSION=master

ENV CFLAGS="-Os -march=x86-64"
ENV LDFLAGS="-s"

COPY --from=postgres /usr/local/pgsql/include /usr/include
COPY --from=postgres /usr/local/pgsql/lib     /usr/lib

WORKDIR /tmp

ADD https://github.com/php/php-src/archive/${PHP_VERSION}.tar.gz .

RUN apk add --no-cache \
    # generic dependencies for compiling the source
    autoconf \
    automake \
    build-base \
    bison \
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
    gd-dev \
    gmp-dev \
    libffi-dev \
    libgcrypt-dev \
    libpng-dev \
    libsodium-dev \
    libxml2-dev \
    libxslt-dev \
    libzip-dev \
    oniguruma-dev \
    openssl-dev \
    readline-dev \
    sqlite-dev \
 && tar zxof ${PHP_VERSION}.tar.gz \
 && cd php-src-${PHP_VERSION} \
 && ./buildconf \
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
    --with-ffi \
    --with-gmp \
    --with-mysqli \
    --with-openssl \
    --with-password-argon2 \
    --with-pdo-mysql \
    --with-pdo-pgsql \
    --with-pear \
    --with-pgsql \
    --with-readline \
    --with-sodium \
    --with-xmlrpc \
    --with-xsl \
    --with-zip \
    --with-zlib \
 && make -j$(nproc) \
 && make install

RUN rm -rf php-src-${PHP_VERSION} \
 && tar zxof ${PHP_VERSION}.tar.gz \
 && cd php-src-${PHP_VERSION} \
 && ./buildconf \
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
    --with-ffi \
    --with-gmp \
    --with-mysqli \
    --with-openssl \
    --with-password-argon2 \
    --with-pdo-mysql \
    --with-pdo-pgsql \
    --with-pear \
    --with-pgsql \
    --with-sodium \
    --with-xmlrpc \
    --with-xsl \
    --with-zip \
    --with-zlib \
 && make -j$(nproc) \
 && mv sapi/fpm/php-fpm /usr/sbin/php-fpm \
 && cp php.ini-production /tmp/php.ini \
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
        -e 's#;catch_workers_output = yes#catch_workers_output = yes#' \
        -e 's#;decorate_workers_output = no#decorate_workers_output = no#' \
        sapi/fpm/www.conf.in > /tmp/www.conf \

 && upx --lzma /usr/bin/php /usr/sbin/php-fpm

FROM 1maa/alpine:3.12

COPY --from=postgres /usr/local/pgsql/lib/libpq.so.5.12 /usr/lib/libpq.so.5

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
    gmp \
    libcurl \
    libffi \
    libgd \
    libsodium \
    libxml2 \
    libxslt \
    libzip \
    oniguruma \
    readline \
    sqlite-libs \
 && rm /etc/php/mods-available/*

COPY etc/mods-available/opcache.ini /etc/php/mods-available/opcache.ini

EXPOSE 9000

CMD ["/usr/sbin/php-fpm", "-R"]
