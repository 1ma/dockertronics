FROM 1maa/alpine:3.8

ENV PHP_VERSION=5.6.40
ENV GEARMAN_VERSION=1.1.2
ENV MAXMINDDB_VERSION=1.6.0
ENV MEMCACHED_VERSION=2.2.0
ENV XHPROF_VERSION=2.1.1

ENV CFLAGS="-Os -march=x86-64"
ENV LDFLAGS="-s"

WORKDIR /tmp

RUN apk upgrade --no-cache \
 && apk add --no-cache \
    # generic dependencies for compiling the source
    autoconf \
    automake \
    build-base \
    file \
    flex \
    libtool \
    re2c \

    upx \

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
    libressl-dev \
    libsodium-dev \
    libssh2-dev \
    libxml2-dev \
    libxslt-dev \
    libzip-dev \
    postgresql-dev \
    rabbitmq-c-dev \
    readline-dev \
 && wget -q https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz \
 && tar zxof php-${PHP_VERSION}.tar.gz \
 && cd ./php-${PHP_VERSION} \
 && ./configure \
    EXTENSION_DIR="/usr/lib/php" \

    --prefix=/usr \
    --sysconfdir=/etc/php/cli \
    --with-config-file-path=/etc/php/cli \
    --with-config-file-scan-dir=/etc/php/cli/conf.d \

    --enable-cli \
    --disable-fpm \
    --disable-cgi \
    --disable-phpdbg \

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

# Unsupported in PHP5
#RUN wget -q https://github.com/tideways/php-xhprof-extension/archive/v${XHPROF_VERSION}.tar.gz \
# && tar zxof v${XHPROF_VERSION}.tar.gz \
# && cd ./php-xhprof-extension-${XHPROF_VERSION} \
# && phpize \
# && ./configure \
# && make \
# && make install

RUN wget -q https://github.com/maxmind/MaxMind-DB-Reader-php/archive/v${MAXMINDDB_VERSION}.tar.gz \
 && tar zxof v${MAXMINDDB_VERSION}.tar.gz \
 && cd MaxMind-DB-Reader-php-${MAXMINDDB_VERSION}/ext \
 && phpize \
 && ./configure \
 && make \
 && make install

# Installed with PECL
#RUN wget -q https://github.com/php/pecl-networking-gearman/archive/gearman-${GEARMAN_VERSION}.tar.gz \
# && tar zxof gearman-${GEARMAN_VERSION}.tar.gz \
# && cd pecl-networking-gearman-gearman-${GEARMAN_VERSION} \
# && phpize \
# && ./configure \
# && make \
# && make install

RUN pecl channel-update pecl.php.net \
 && pecl install \
    igbinary-2.0.8 \
    msgpack-0.5.7

RUN wget -q https://github.com/php-memcached-dev/php-memcached/archive/${MEMCACHED_VERSION}.tar.gz \
 && tar zxof ${MEMCACHED_VERSION}.tar.gz \
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
    apcu-4.0.11 \
    event \
    gearman-${GEARMAN_VERSION} \
    gnupg \
    libsodium-1.0.7 \
    mongodb \
    protobuf \
    rdkafka \
    redis-4.3.0 \
    ssh2-0.13 \
    xdebug-2.5.5 \
    xhprof-${XHPROF_VERSION} \
    yar-1.2.5

RUN rm -rf php-${PHP_VERSION} \
 && tar zxof php-${PHP_VERSION}.tar.gz \
 && cd ./php-${PHP_VERSION} \
 && ./configure \
    EXTENSION_DIR="/usr/lib/php" \

    --prefix=/usr \
    --sysconfdir=/etc/php/fpm \
    --with-config-file-path=/etc/php/fpm \
    --with-config-file-scan-dir=/etc/php/fpm/conf.d \

    --enable-fpm \
    --disable-cli \
    --disable-cgi \
    --disable-phpdbg \

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

 && sed -e 's#;daemonize = yes#daemonize = no#' \
        -e 's#;error_log = log/php-fpm.log#error_log = /dev/stderr#' \
        -e 's#user = @php_fpm_user@#user = root#' \
        -e 's#group = @php_fpm_group@#group = root#' \
        -e 's#listen = 127.0.0.1:9000#listen = 9000#' \
        -e 's#;catch_workers_output = yes#catch_workers_output = yes#' \
        sapi/fpm/php-fpm.conf.in > /tmp/php-fpm.conf


FROM 1maa/alpine:3.8

COPY etc /etc/php

COPY --from=0 /tmp/php.ini      /etc/php/cli/php.ini
COPY --from=0 /tmp/php.ini      /etc/php/fpm/php.ini
COPY --from=0 /tmp/php-fpm.conf /etc/php/fpm/php-fpm.conf
COPY --from=0 /usr/bin/php      /usr/bin/php
COPY --from=0 /usr/sbin/php-fpm /usr/sbin/php-fpm
COPY --from=0 /usr/lib/php/*.so /usr/lib/php/

RUN apk upgrade --no-cache \
 && apk add --no-cache \
    gearman-libs@edge-testing \
    gmp \
    gpgme \
    libcurl \
    libevent \
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
    rabbitmq-c \
    readline \
 && rm /etc/php/mods-available/amqp.ini \
 && rm /etc/php/mods-available/csv.ini \
 && rm /etc/php/mods-available/ds.ini \
 && rm /etc/php/mods-available/pcov.ini \
 && rm /etc/php/mods-available/tideways_xhprof.ini \
 && rm /etc/php/mods-available/uv.ini

EXPOSE 9000

CMD ["/usr/sbin/php-fpm", "-R"]
