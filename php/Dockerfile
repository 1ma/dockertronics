FROM alpine:3.23 AS build

ARG PHP_VERSION

ENV CFLAGS="-g0 -Os -fstack-protector-strong -fpic -fpie -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
ENV LDFLAGS="-Wl,--strip-all -Wl,-O1 -pie"

WORKDIR /tmp

ADD https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz .
ADD https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz.asc .

COPY release-pubkeys.asc .

RUN apk add --no-cache \
    gnupg \
 && gpg --import release-pubkeys.asc \
 && gpg --verify php-${PHP_VERSION}.tar.gz.asc php-${PHP_VERSION}.tar.gz

RUN tar zxof php-${PHP_VERSION}.tar.gz

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
    rabbitmq-c-dev \
    sqlite-dev \
    tidyhtml-dev \
    unixodbc-dev

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
    --with-pdo-odbc=shared,unixODBC,/usr \
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
    --with-password-argon2 \
 && make -j$(nproc) \
 && make install

RUN cp php.ini-development          /usr/local/etc/php.ini
COPY --chmod=644 extensions.ini     /usr/local/etc/conf.d/extensions.ini
COPY --chmod=644 php-overrides.ini  /usr/local/etc/conf.d/php-overrides.ini
COPY --chmod=644 fpm-overrides.conf /usr/local/etc/php-fpm.d/fpm-overrides.conf

# Append zend_extension=opcache.so to extensions.ini for versions of PHP lower than 8.5.0
RUN set -eu; \
  if php -r 'exit(version_compare(PHP_VERSION, "8.5.0", "<") ? 0 : 1);'; then \
    echo 'zend_extension=opcache.so' >> /usr/local/etc/conf.d/extensions.ini; \
  fi

RUN apk add --no-cache \
    autoconf \
    libmemcached-dev \
    librdkafka-dev \
    libsecp256k1-dev \
    libssh2-dev \
    libuv-dev \
    yaml-dev

ADD https://github.com/php/pie/releases/latest/download/pie.phar /usr/local/bin/pie

RUN chmod +x /usr/local/bin/pie
RUN pie install --skip-enable-extension apcu/apcu
RUN pie install --skip-enable-extension arnaud-lb/inotify
RUN pie install --skip-enable-extension girgias/csv
RUN pie install --skip-enable-extension mongodb/mongodb-extension
RUN pie install --skip-enable-extension pecl/pcov
RUN pie install --skip-enable-extension pecl/yaml
RUN pie install --skip-enable-extension rdkafka/rdkafka
RUN pie install --skip-enable-extension uma/secp256k1-nostr
RUN pie install --skip-enable-extension xdebug/xdebug

RUN pecl channel-update pecl.php.net \
 && MAKEFLAGS="-j$(nproc)" pecl install \
    amqp \
    ds \
    excimer \
    igbinary \
    msgpack \
    ssh2 \
    uv-beta \
 && MAKEFLAGS="-j$(nproc)" pecl install \
    --configureoptions 'enable-memcached-igbinary="yes" enable-memcached-msgpack="yes" enable-memcached-json="yes" enable-redis-igbinary="yes" enable-redis-lzf="yes" enable-redis-zstd="yes" enable-redis-msgpack="yes" enable-redis-lz4="yes" enable-msgpack="yes"' \
    memcached \
    redis \
    yar

RUN chmod 644 $(php-config --extension-dir)/*.so


FROM alpine:3.23 AS prepare

WORKDIR /tmp

COPY --from=build /usr/local/bin/php                          /tmp/bin/php
COPY --from=build /usr/local/etc/conf.d                       /tmp/etc/conf.d
COPY --from=build /usr/local/etc/php-fpm.conf.default         /tmp/etc/php-fpm.conf
COPY --from=build /usr/local/etc/php-fpm.d/www.conf.default   /tmp/etc/php-fpm.d/default-www.conf
COPY --from=build /usr/local/etc/php-fpm.d/fpm-overrides.conf /tmp/etc/php-fpm.d/fpm-overrides.conf
COPY --from=build /usr/local/etc/php.ini                      /tmp/etc/php.ini
COPY --from=build /usr/local/lib/php/extensions               /tmp/lib/php/extensions
COPY --from=build /usr/local/php/php/fpm/status.html          /tmp/php/php/fpm/status.html
COPY --from=build /usr/local/sbin/php-fpm                     /tmp/sbin/php-fpm

COPY --chmod=755 entrypoint.sh /tmp/bin/entrypoint.sh

ADD https://getcomposer.org/download/latest-stable/composer.phar .
ADD https://getcomposer.org/download/latest-stable/composer.phar.asc .

COPY composer-pubkey.asc .

RUN apk add --no-cache \
    gnupg \
 && gpg --import composer-pubkey.asc \
 && gpg --verify composer.phar.asc composer.phar \
 && rm composer.phar.asc composer-pubkey.asc \
 && chmod 755 composer.phar \
 && mv composer.phar bin/composer

RUN apk add --no-cache \
    upx \
 && upx --lzma /tmp/bin/php /tmp/sbin/php-fpm


FROM alpine:3.23 AS final

COPY --from=prepare /tmp/ /usr/local/

RUN apk add --no-cache \
    7zip \
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

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/local/sbin/php-fpm", "--nodaemonize"]
