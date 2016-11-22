FROM 1maa/php-cli:7.0

RUN apk add --no-cache \
    apache2 \
    php7-apache2 \
 && mkdir /run/apache2

EXPOSE 80 443

STOPSIGNAL SIGWINCH

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
