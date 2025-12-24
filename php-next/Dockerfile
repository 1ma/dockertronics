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
    enchant2-dev \
    freetds-dev \
    freetype-dev \
    gettext-dev \
    gmp-dev \
    libavif-dev \
    libedit-dev \
    libffi-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libpq-dev \
    libsodium-dev \
    libwebp-dev \
    libxml2-dev \
    libxpm-dev \
    libxslt-dev \
    libzip-dev \
    lmdb-dev \
    net-snmp-dev \
    oniguruma-dev \
    openldap-dev \
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
    --with-enchant=shared \
    --with-ffi=shared \
    --with-gettext=shared \
    --with-gmp=shared \
    --with-iconv=shared \
    --with-ldap=shared \
    --with-libedit=shared \
    --with-mysqli=shared \
    --with-openssl=shared \
    --with-pdo-dblib=shared \
    --with-pdo-mysql=shared \
    --with-pdo-odbc=shared,unixODBC \
    --with-pdo-pgsql=shared \
    --with-pdo-sqlite=shared \
    --with-pgsql=shared \
    --with-snmp=shared \
    --with-sodium=shared \
    --with-sqlite3=shared \
    --with-tidy=shared \
    --with-xsl=shared \
    --with-zip=shared \
    --with-zlib=shared \
\
    --enable-gd-jis-conv \
    --with-avif \
    --with-freetype \
    --with-jpeg \
    --with-webp \
    --with-xpm \
\
    --with-db4 \
    --with-lmdb \
\
    --with-ldap-sasl \
\
    --with-openssl-argon2 \
    --with-password-argon2

RUN make -j4
RUN make install

RUN cp php.ini-development /usr/local/etc/php.ini
COPY extensions.ini /usr/local/etc/conf.d/extensions.ini

RUN apk add --no-cache autoconf
RUN pecl channel-update pecl.php.net \
 && MAKEFLAGS="-j$(nproc)" pecl install \
    apcu \
    csv \
    ds \
    igbinary \
    mongodb \
    msgpack \
    pcov \
    redis \
    simdjson \
    xdebug \
    yar
