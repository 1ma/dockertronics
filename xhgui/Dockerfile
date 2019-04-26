FROM 1maa/php-dev:7.3

ENV XHGUI_RELEASE=0.9.0

WORKDIR /tmp

RUN apk add -U curl \
 && curl -LOsS https://github.com/perftools/xhgui/archive/${XHGUI_RELEASE}.tar.gz \
 && tar zxf ${XHGUI_RELEASE}.tar.gz \
 && mv xhgui-${XHGUI_RELEASE} xhgui \
 && cd xhgui \
 && composer install --no-dev


FROM php:7.3-apache

RUN pecl install \
    mongodb \
 && docker-php-ext-enable mongodb \
 && a2enmod rewrite \
 && service apache2 restart

COPY          vhost.conf /etc/apache2/sites-available/000-default.conf
COPY --from=0 /tmp/xhgui /var/www/xhgui

WORKDIR /var/www/xhgui

EXPOSE 80
