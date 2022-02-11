FROM alpine:latest AS librdkafka

# Versions available on Ubuntu: https://packages.ubuntu.com/search?keywords=librdkafka
ENV LIBRDKAFKA_VERSION=0.11.3
ENV CFLAGS="-Os -march=x86-64"
ENV LDFLAGS="-s"

WORKDIR /tmp

ADD https://github.com/edenhill/librdkafka/archive/v${LIBRDKAFKA_VERSION}.zip .

RUN apk add --no-cache \
    bash \
    build-base \
    cyrus-sasl-dev \
    lz4-dev \
    openssl-dev \
    python3 \
    zlib-dev \
 && ln -s /usr/bin/python3 /usr/bin/python \
 && unzip v${LIBRDKAFKA_VERSION}.zip

WORKDIR /tmp/librdkafka-${LIBRDKAFKA_VERSION}

RUN ./configure --help \
 && ./configure

RUN make -j$(nproc)

RUN make install

RUN find examples/* -executable -exec cp {} /usr/local/bin \;

FROM 1maa/alpine:latest AS build

ENV PHP_VERSION=7.3.33

ENV CFLAGS="-Os -march=x86-64"
ENV LDFLAGS="-s"

WORKDIR /tmp

COPY 7.3/pubkeys.asc .

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
    libmaxminddb-dev \
    libmemcached-dev \
    libpng-dev \
    libpq-dev \
    libsodium-dev \
    libssh2-dev \
    libxml2-dev \
    libxslt-dev \
    libzip-dev \
    openssl-dev \
    rabbitmq-c-dev \
    readline-dev \
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
    --enable-mbstring \
    --enable-opcache \
    --enable-pcntl \
    --enable-shmop \
    --enable-soap \
    --enable-sockets \
    --enable-wddx \
    --enable-zip \
\
    --with-bz2 \
    --with-curl \
    --with-gd \
    --with-gmp \
    --with-libzip \
    --with-mysqli \
    --with-openssl \
    --with-password-argon2 \
    --with-pdo-mysql \
    --with-pdo-pgsql \
    --with-pgsql \
    --with-readline \
    --with-sodium \
    --with-xmlrpc \
    --with-xsl \
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
    --enable-mbstring \
    --enable-opcache \
    --enable-shmop \
    --enable-soap \
    --enable-sockets \
    --enable-wddx \
    --enable-zip \
\
    --with-bz2 \
    --with-curl \
    --with-gd \
    --with-gmp \
    --with-libzip \
    --with-mysqli \
    --with-openssl \
    --with-password-argon2 \
    --with-pdo-mysql \
    --with-pdo-pgsql \
    --with-pgsql \
    --with-sodium \
    --with-xmlrpc \
    --with-xsl \
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

COPY --from=librdkafka /usr/local/include /usr/include
COPY --from=librdkafka /usr/local/lib     /usr/lib

RUN apk add --no-cache libsasl lz4-libs && pecl channel-update pecl.php.net \
 && pecl install \
    amqp \
    apcu \
    csv-0.3.1 \
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
    rdkafka-5.0.2 \
    redis \
    ssh2-beta \
    xdebug \
    yaml \
    yar \
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

COPY --from=librdkafka /usr/local/bin /usr/bin
COPY --from=librdkafka /usr/local/lib /usr/lib

RUN apk add --no-cache \
    argon2-libs \
    gmp \
    gpgme \
    libcurl \
    libevent \
    libgd \
    libmaxminddb \
    libmemcached-libs \
    libpq \
    libsasl \
    libsodium \
    libssh2 \
    libxml2 \
    libxslt \
    libzip \
    lz4-libs \
    rabbitmq-c \
    readline \
    yaml

EXPOSE 9000

CMD ["/usr/sbin/php-fpm", "-R"]


FROM php AS build-dev

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_HOME=/opt/composer

COPY composer-pubkey.asc .

ADD https://getcomposer.org/download/latest-stable/composer.phar .
ADD https://getcomposer.org/download/latest-stable/composer.phar.asc .

RUN gpg --import composer-pubkey.asc \
 && gpg --verify composer.phar.asc composer.phar

RUN php composer.phar global config allow-plugins.uma/composer-psysh true \
 && php composer.phar global config bin-dir /usr/local/bin \
 && php composer.phar global config minimum-stability dev \
 && php composer.phar global config prefer-stable true \
 && php composer.phar global require --prefer-dist \
    composer/composer \
    deployer/deployer \
    friendsofphp/php-cs-fixer \
    phing/phing \
    phploc/phploc \
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
