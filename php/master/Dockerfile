FROM 1maa/alpine:3.11

ENV PHP_VERSION=master
ENV GEARMAN_VERSION=2.0.6
ENV MAXMINDDB_VERSION=1.6.0
ENV MEMCACHED_VERSION=3.1.5
ENV XHPROF_VERSION=5.0.2

ENV CFLAGS="-O3 -march=x86-64"
ENV LDFLAGS="-s"

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

    upx \

    # dependencies for building specific extensions
    argon2-dev \
    bzip2-dev \
    curl-dev \
    gd-dev \
    gearman-dev@edge-testing \
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
    libuv-dev \
    libxml2-dev \
    libxslt-dev \
    libzip-dev \
    oniguruma-dev \
    openssl-dev \
    postgresql-dev \
    rabbitmq-c-dev \
    readline-dev \
    sqlite-dev \
 && tar zxof ${PHP_VERSION}.tar.gz \
 && cd php-src-${PHP_VERSION} \
 && ./buildconf \
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
    --enable-gd \
    --enable-mbstring \
    --enable-opcache \
    --enable-pcntl \
    --enable-shmop \
    --enable-soap \
    --enable-sockets \

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

# RUN wget -q https://github.com/tideways/php-xhprof-extension/archive/v${XHPROF_VERSION}.tar.gz \
#  && tar zxof v${XHPROF_VERSION}.tar.gz \
#  && cd ./php-xhprof-extension-${XHPROF_VERSION} \
#  && phpize \
#  && ./configure \
#  && make \
#  && make install

# RUN wget -q https://github.com/maxmind/MaxMind-DB-Reader-php/archive/v${MAXMINDDB_VERSION}.tar.gz \
#  && tar zxof v${MAXMINDDB_VERSION}.tar.gz \
#  && cd MaxMind-DB-Reader-php-${MAXMINDDB_VERSION}/ext \
#  && phpize \
#  && ./configure \
#  && make \
#  && make install

# RUN wget -q https://github.com/php/pecl-networking-gearman/archive/gearman-${GEARMAN_VERSION}.tar.gz \
#  && tar zxof gearman-${GEARMAN_VERSION}.tar.gz \
#  && cd pecl-networking-gearman-gearman-${GEARMAN_VERSION} \
#  && phpize \
#  && ./configure \
#  && make \
#  && make install

RUN sed -i "s#option\[name\]#option\['name'\]#" /usr/lib/php/PEAR/Builder.php \
 && pecl channel-update pecl.php.net \
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
#    amqp \         # borked
    apcu \
    csv \
#    ds \           # borked
#    event \        # borked
#    gnupg \        # borked
    mongodb \
    pcov \
#    protobuf \     # borked
    rdkafka \
    redis \
#    ssh2-beta \    # borked
    uv-beta \
#    xdebug         # borked

RUN rm -rf php-src-${PHP_VERSION} \
 && tar zxof ${PHP_VERSION}.tar.gz \
 && cd php-src-${PHP_VERSION} \
 && ./buildconf \
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
    --enable-gd \
    --enable-mbstring \
    --enable-opcache \
    --enable-shmop \
    --enable-soap \
    --enable-sockets \

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

 && sed -e 's#@php_fpm_sysconfdir@#/etc/php/fpm#' \
        -e 's#;daemonize = yes#daemonize = no#' \
        -e 's#;error_log = log/php-fpm.log#error_log = /dev/stderr#' \
        -e 's#;log_buffering = no#log_buffering = yes#' \
        -e 's#;log_limit = 4096#log_limit = 65536#' \
        sapi/fpm/php-fpm.conf.in > /tmp/php-fpm.conf \

 && sed -e 's#user = @php_fpm_user@#user = root#' \
        -e 's#group = @php_fpm_group@#group = root#' \
        -e 's#listen = 127.0.0.1:9000#listen = 9000#' \
        -e 's#;catch_workers_output = yes#catch_workers_output = yes#' \
        -e 's#;decorate_workers_output = no#decorate_workers_output = no#' \
        sapi/fpm/www.conf.in > /tmp/www.conf \

 && upx --lzma /usr/bin/php /usr/sbin/php-fpm


FROM 1maa/alpine:3.11

COPY etc /etc/php

COPY --from=0 /tmp/php.ini      /etc/php/cli/php.ini
COPY --from=0 /tmp/php.ini      /etc/php/fpm/php.ini
COPY --from=0 /tmp/php-fpm.conf /etc/php/fpm/php-fpm.conf
COPY --from=0 /tmp/www.conf     /etc/php/fpm/php-fpm.d/www.conf
COPY --from=0 /usr/bin/php      /usr/bin/php
COPY --from=0 /usr/sbin/php-fpm /usr/sbin/php-fpm
COPY --from=0 /usr/lib/php/*.so /usr/lib/php/

RUN apk add --no-cache \
    argon2-libs \
    gearman-libs@edge-testing \
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
    oniguruma \
    rabbitmq-c \
    readline \
    sqlite-libs \
 && rm /etc/php/mods-available/amqp.ini \
 && rm /etc/php/mods-available/ds.ini \
 && rm /etc/php/mods-available/event.ini \
 && rm /etc/php/mods-available/gearman.ini \
 && rm /etc/php/mods-available/gnupg.ini \
 && rm /etc/php/mods-available/maxminddb.ini \
 && rm /etc/php/mods-available/memcached.ini \
 && rm /etc/php/mods-available/mongodb.ini \
 && rm /etc/php/mods-available/msgpack.ini \
 && rm /etc/php/mods-available/protobuf.ini \
 && rm /etc/php/mods-available/rdkafka.ini \
 && rm /etc/php/mods-available/redis.ini \
 && rm /etc/php/mods-available/ssh2.ini \
 && rm /etc/php/mods-available/tideways_xhprof.ini \
 && rm /etc/php/mods-available/uv.ini \
 && rm /etc/php/mods-available/xdebug.ini

EXPOSE 9000

CMD ["/usr/sbin/php-fpm", "-R"]
