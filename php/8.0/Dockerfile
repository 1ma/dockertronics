FROM 1maa/alpine:3.14 AS build

ENV PHP_VERSION=8.0.11
ENV XHPROF_VERSION=5.0.4

ENV CFLAGS="-Os -march=x86-64"
ENV LDFLAGS="-s"

WORKDIR /tmp

COPY 8.0/pubkeys.asc .

ADD https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz .
ADD https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz.asc .

RUN apk add --no-cache gnupg \
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
    gd-dev \
    gmp-dev \
    gpgme-dev \
    libevent-dev \
    libffi-dev \
    libgcrypt-dev \
    libmaxminddb-dev \
    libmemcached-dev \
    libpng-dev \
    librdkafka-dev \
    libsodium-dev \
    libssh2-dev \
    libxml2-dev \
    libxslt-dev \
    libzip-dev \
    oniguruma-dev \
    openssl-dev \
    postgresql-dev \
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

RUN wget -q https://github.com/tideways/php-xhprof-extension/archive/v${XHPROF_VERSION}.tar.gz \
 && tar zxof v${XHPROF_VERSION}.tar.gz \
 && cd ./php-xhprof-extension-${XHPROF_VERSION} \
 && phpize \
 && ./configure \
 && make \
 && make install

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
ADD https://pecl.php.net/get/ssh2-beta .
ADD https://pecl.php.net/get/xdebug .
ADD https://pecl.php.net/get/yaml .
ADD https://pecl.php.net/get/yar .

RUN apk del --no-cache postgresql-dev \
 && pecl channel-update pecl.php.net \
 && pecl install \
    amqp-beta \
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
    ssh2-beta \
    xdebug \
    yaml \
    yar \
 && chmod 644 /usr/lib/php/*.so \
 && strip --strip-all /usr/lib/php/*.so


FROM 1maa/alpine:3.14

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
    libxml2 \
    libxslt \
    libzip \
    oniguruma \
    rabbitmq-c \
    readline \
    sqlite-libs \
    yaml \
 && rm /etc/php/mods-available/amqp.ini \
 && rm /etc/php/mods-available/ssh2.ini

EXPOSE 9000

CMD ["/usr/sbin/php-fpm", "-R"]
