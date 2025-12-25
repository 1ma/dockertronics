FROM alpine:3.23 AS build

ARG PHP_VERSION=8.4.16

ENV CFLAGS="-g0 -Os"
ENV LDFLAGS="-Wl,--strip-all"

WORKDIR /tmp

COPY pubkeys.asc .

ADD https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz .
ADD https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz.asc .

RUN apk add --no-cache \
    gnupg \
 && gpg --import pubkeys.asc \
 && gpg --verify php-${PHP_VERSION}.tar.gz.asc php-${PHP_VERSION}.tar.gz

RUN apk add --no-cache \
    argon2-dev \
    build-base \
    bzip2-dev \
    curl-dev \
    db-dev \
    freetds-dev \
    gmp-dev \
    libedit-dev \
    libffi-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libpq-dev \
    libsodium-dev \
    libxml2-dev \
    libxslt-dev \
    libzip-dev \
    lmdb-dev \
    oniguruma-dev \
    openssl-dev \
    pkgconf \
    sqlite-dev \
    tidyhtml-dev \
    unixodbc-dev

RUN tar zxof php-${PHP_VERSION}.tar.gz

WORKDIR /tmp/php-${PHP_VERSION}

RUN ./configure \
    --prefix=/usr/local \
    --with-config-file-path=/usr/local/etc \
    --with-config-file-scan-dir=/usr/local/etc/conf.d \
\
    --disable-cgi \
    --disable-phpdbg \
    --enable-cli \
    --enable-fpm \
    --with-fpm-group=nobody \
    --with-fpm-user=nobody \
    --with-pear \
\
    --enable-bcmath=shared \
    --enable-calendar=shared \
    --enable-dba=shared \
    --enable-exif=shared \
    --enable-ftp=shared \
    --enable-gd=shared \
    --enable-mbstring=shared \
    --enable-mysqlnd=shared \
    --enable-pcntl=shared \
    --enable-shmop=shared \
    --enable-soap=shared \
    --enable-sockets=shared \
    --enable-sysvmsg=shared \
    --enable-sysvsem=shared \
    --enable-sysvshm=shared \
    --with-bz2=shared \
    --with-curl=shared \
    --with-ffi=shared \
    --with-gmp=shared \
    --with-iconv=shared \
    --with-libedit=shared \
    --with-mysqli=shared \
    --with-openssl=shared \
    --with-pdo-dblib=shared \
    --with-pdo-mysql=shared \
    --with-pdo-odbc=shared,unixODBC \
    --with-pdo-pgsql=shared \
    --with-pdo-sqlite=shared \
    --with-pgsql=shared \
    --with-sodium=shared \
    --with-sqlite3=shared \
    --with-tidy=shared \
    --with-xsl=shared \
    --with-zip=shared \
    --with-zlib=shared \
\
    --enable-gd-jis-conv \
    --with-jpeg \
\
    --with-db4 \
    --with-lmdb \
\
    --with-openssl-argon2 \
    --with-password-argon2

RUN make -j4
RUN make install

RUN cp php.ini-development /usr/local/etc/php.ini
COPY --chmod=644 extensions.ini /usr/local/etc/conf.d/extensions.ini

RUN apk add --no-cache \
    autoconf \
    libmemcached-dev \
    librdkafka-dev \
    libsecp256k1-dev \
    libssh2-dev \
    libuv-dev \
    rabbitmq-c-dev \
    yaml-dev

RUN pecl channel-update pecl.php.net \
 && MAKEFLAGS="-j$(nproc)" pecl install \
    amqp \
    apcu \
    csv \
    ds \
    excimer \
    igbinary \
    memcached \
    mongodb \
    msgpack \
    pcov \
    rdkafka \
    redis \
    simdjson \
    ssh2 \
    uv-beta \
    xdebug \
    yaml \
    yar

ADD https://github.com/php/pie/releases/latest/download/pie.phar /usr/local/bin/pie

RUN chmod +x /usr/local/bin/pie
RUN pie install --skip-enable-extension uma/secp256k1-nostr

FROM alpine:3.23 AS prepare

WORKDIR /tmp

COPY --from=build /usr/local/bin/php                        /tmp/bin/php
COPY --from=build /usr/local/etc/conf.d                     /tmp/etc/conf.d
COPY --from=build /usr/local/etc/php-fpm.conf.default       /tmp/etc/php-fpm.conf
COPY --from=build /usr/local/etc/php-fpm.d/www.conf.default /tmp/etc/php-fpm.d/www.conf
COPY --from=build /usr/local/lib/php/extensions             /tmp/lib/php/extensions
COPY --from=build /usr/local/php/php/fpm/status.html        /tmp/php/php/fpm/status.html
COPY --from=build /usr/local/sbin/php-fpm                   /tmp/sbin/php-fpm

COPY composer-pubkey.asc .

ADD https://getcomposer.org/download/latest-stable/composer.phar .
ADD https://getcomposer.org/download/latest-stable/composer.phar.asc .

RUN apk add --no-cache \
    gnupg \
 && gpg --import composer-pubkey.asc \
 && gpg --verify composer.phar.asc composer.phar

RUN rm composer.phar.asc composer-pubkey.asc \
 && chmod 755 composer.phar \
 && chmod 644 lib/php/extensions/no-debug-non-zts-20240924/*.so \
 && mv composer.phar bin/composer


FROM alpine:3.23 AS final

COPY --from=prepare /tmp/ /usr/local/

RUN apk add --no-cache \
    argon2-libs \
    db \
    freetds \
    git \
    gmp \
    libbz2 \
    libcurl \
    libedit \
    libffi \
    libjpeg-turbo \
    libmemcached-libs \
    libpng \
    libpq \
    librdkafka \
    libsecp256k1 \
    libsodium \
    libssh2 \
    libssl3 \
    libuv \
    libxml2 \
    libxslt \
    libzip \
    lmdb \
    oniguruma \
    rabbitmq-c \
    sqlite-libs \
    tidyhtml-libs \
    unixodbc \
    yaml
