FROM 1maa/php-cli:7.0

RUN apk add --no-cache \
    alpine-sdk \
    autoconf \
    php7-dev \
    php7-pear \
 && sed -i 's@exec $PHP -C -n -q@exec $PHP -C -q@' /usr/bin/pecl # fixes nasty PECL bug documented by user bluebinary at: http://serverfault.com/a/612038
