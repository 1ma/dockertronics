FROM 1maa/php:7.0

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_HOME=/opt/composer

ADD https://getcomposer.org/composer.phar .

RUN php composer.phar global config bin-dir /usr/local/bin \
 && php composer.phar global config minimum-stability dev \
 && php composer.phar global config prefer-stable true \
 && php composer.phar global require --prefer-dist \
    composer/composer \
    d11wtq/boris \
    deployer/deployer \
    phing/phing \
    phploc/phploc \
    phpmetrics/phpmetrics \
    psy/psysh \
    sensiolabs-de/deptrac-shim \
 && rm -rf ${COMPOSER_HOME}/.htaccess ${COMPOSER_HOME}/cache


FROM 1maa/php:7.0

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_HOME=/opt/composer

COPY etc /etc/php

COPY --from=0 ${COMPOSER_HOME} ${COMPOSER_HOME}
COPY --from=0 /usr/local/bin /usr/local/bin
