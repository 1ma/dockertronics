FROM 1maa/postgres:13-src AS postgres

FROM 1maa/alpine:3.13 AS build

ENV PHP_VERSION=7.0.33
ENV GEARMAN_VERSION=2.0.6
ENV MAXMINDDB_VERSION=1.6.0
ENV MEMCACHED_VERSION=3.1.5
ENV XHPROF_VERSION=5.0.4

ENV CFLAGS="-Os -march=x86-64"
ENV LDFLAGS="-s"

COPY --from=postgres /usr/local/pgsql/include /usr/include
COPY --from=postgres /usr/local/pgsql/lib     /usr/lib

WORKDIR /tmp

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
    bzip2-dev \
    curl-dev \
    gd-dev \
    gearman-dev@edge-testing \
    gmp-dev \
    gpgme-dev \
    libevent-dev \
    libmaxminddb-dev \
    libmemcached-dev \
    libpng-dev \
    librdkafka-dev \
    libsodium-dev \
    libssh2-dev \
    libuv-dev \
    libxml2-dev \
    libxslt-dev \
    libzip-dev \
    openssl-dev \
    rabbitmq-c-dev \
    readline-dev \
 && wget -q https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz \
 && tar zxof php-${PHP_VERSION}.tar.gz \
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
    --enable-exif \
    --enable-ftp \
    --enable-mbstring \
    --enable-opcache \
    --enable-pcntl \
    --enable-shmop \
    --enable-soap \
    --enable-sockets \
    --enable-wddx \
    --enable-zend-signals \
    --enable-zip \
\
    --with-bz2 \
    --with-curl \
    --with-gd \
    --with-gmp \
    --with-libzip \
    --with-mysqli \
    --with-openssl \
    --with-pdo-mysql \
    --with-pdo-pgsql \
    --with-pgsql \
    --with-readline \
    --with-xmlrpc \
    --with-xsl \
    --with-zlib \
 && make -j$(nproc) \
 && make install

RUN wget -q https://github.com/tideways/php-xhprof-extension/archive/v${XHPROF_VERSION}.tar.gz \
 && tar zxof v${XHPROF_VERSION}.tar.gz \
 && cd ./php-xhprof-extension-${XHPROF_VERSION} \
 && phpize \
 && ./configure \
 && make \
 && make install

RUN wget -q https://github.com/maxmind/MaxMind-DB-Reader-php/archive/v${MAXMINDDB_VERSION}.tar.gz \
 && tar zxof v${MAXMINDDB_VERSION}.tar.gz \
 && cd MaxMind-DB-Reader-php-${MAXMINDDB_VERSION}/ext \
 && phpize \
 && ./configure \
 && make \
 && make install

RUN wget -q https://github.com/php/pecl-networking-gearman/archive/gearman-${GEARMAN_VERSION}.tar.gz \
 && tar zxof gearman-${GEARMAN_VERSION}.tar.gz \
 && cd pecl-networking-gearman-gearman-${GEARMAN_VERSION} \
 && phpize \
 && ./configure \
 && make \
 && make install

RUN pecl channel-update pecl.php.net \
 && pecl install \
    igbinary \
    msgpack

RUN wget -q https://github.com/php-memcached-dev/php-memcached/archive/v${MEMCACHED_VERSION}.tar.gz \
 && tar zxof v${MEMCACHED_VERSION}.tar.gz \
 && cd php-memcached-${MEMCACHED_VERSION} \
 && phpize \
 && ./configure \
    --enable-memcached-igbinary \
    --enable-memcached-json \
    --enable-memcached-msgpack \
    --enable-memcached-protocol \
    --enable-memcached-sasl \
    --enable-memcached-session \
 && make \
 && make install

RUN pecl install \
    amqp \
    apcu \
    ds \
    event \
    gnupg \
    libsodium \
    mongodb \
    protobuf \
    rdkafka \
    redis \
    ssh2-beta \
    uv-beta \
    xdebug-2.7.2 \
    yar \
 && chmod 644 /usr/lib/php/*.so \
 && strip --strip-all /usr/lib/php/*.so

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
    --enable-exif \
    --enable-ftp \
    --enable-mbstring \
    --enable-opcache \
    --enable-shmop \
    --enable-soap \
    --enable-sockets \
    --enable-wddx \
    --enable-zend-signals \
    --enable-zip \
\
    --with-bz2 \
    --with-curl \
    --with-gd \
    --with-gmp \
    --with-libzip \
    --with-mysqli \
    --with-openssl \
    --with-pdo-mysql \
    --with-pdo-pgsql \
    --with-pgsql \
    --with-xmlrpc \
    --with-xsl \
    --with-zlib \
 && make -j$(nproc) \
 && mv sapi/fpm/php-fpm /usr/sbin/php-fpm \
 && cp php.ini-production /tmp/php.ini \
\
 && sed -e 's#@php_fpm_sysconfdir@#/etc/php/fpm#' \
        -e 's#;daemonize = yes#daemonize = no#' \
        -e 's#;error_log = log/php-fpm.log#error_log = /dev/stderr#' \
        sapi/fpm/php-fpm.conf.in > /tmp/php-fpm.conf \
\
 && sed -e 's#user = @php_fpm_user@#user = root#' \
        -e 's#group = @php_fpm_group@#group = root#' \
        -e 's#listen = 127.0.0.1:9000#listen = 9000#' \
        -e 's#;clear_env = no#clear_env = no#' \
        -e 's#;catch_workers_output = yes#catch_workers_output = yes#' \
        sapi/fpm/www.conf.in > /tmp/www.conf \

 && upx --lzma /usr/bin/php /usr/sbin/php-fpm

FROM 1maa/alpine:3.13

COPY --from=postgres /usr/local/pgsql/lib/libpq.so.5.13 /usr/lib/libpq.so.5

COPY etc /etc/php

COPY --from=build /tmp/php.ini      /etc/php/cli/php.ini
COPY --from=build /tmp/php.ini      /etc/php/fpm/php.ini
COPY --from=build /tmp/php-fpm.conf /etc/php/fpm/php-fpm.conf
COPY --from=build /tmp/www.conf     /etc/php/fpm/php-fpm.d/www.conf
COPY --from=build /usr/bin/php      /usr/bin/php
COPY --from=build /usr/sbin/php-fpm /usr/sbin/php-fpm
COPY --from=build /usr/lib/php/*.so /usr/lib/php/

RUN apk add --no-cache \
    gearman-libs@edge-testing \
    gmp \
    gpgme \
    libcurl \
    libevent \
    libgd \
    libmaxminddb \
    libmemcached-libs \
    librdkafka \
    libsodium \
    libssh2 \
    libuv \
    libxml2 \
    libxslt \
    libzip \
    rabbitmq-c \
    readline \
 && rm /etc/php/mods-available/csv.ini \
 && rm /etc/php/mods-available/pcov.ini

EXPOSE 9000

CMD ["/usr/sbin/php-fpm", "-R"]
