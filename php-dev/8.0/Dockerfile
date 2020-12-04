FROM 1maa/php:8.0

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_HOME=/opt/composer

ADD https://getcomposer.org/composer.phar .

RUN php composer.phar global config bin-dir /usr/local/bin \
 && php composer.phar global config minimum-stability dev \
 && php composer.phar global config prefer-stable true \
 && php composer.phar global require --prefer-dist --ignore-platform-reqs \
    composer/composer \
    d11wtq/boris \
    deployer/deployer \
    friendsofphp/php-cs-fixer \
    phing/phing \
    phploc/phploc \
    phpmetrics/phpmetrics \
    phpstan/phpstan \
    phpunit/phpunit \
    sensiolabs-de/deptrac-shim \
    vimeo/psalm \
 && rm -rf ${COMPOSER_HOME}/.htaccess ${COMPOSER_HOME}/cache


FROM 1maa/php:8.0

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_HOME=/opt/composer

COPY etc /etc/php

COPY --from=0 ${COMPOSER_HOME} ${COMPOSER_HOME}
COPY --from=0 /usr/local/bin /usr/local/bin
