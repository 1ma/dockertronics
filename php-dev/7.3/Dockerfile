FROM 1maa/php:7.3

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_HOME=/opt/composer

COPY composer-pubkey.asc .

ADD https://getcomposer.org/download/latest-stable/composer.phar .
ADD https://getcomposer.org/download/latest-stable/composer.phar.asc .

RUN gpg --import composer-pubkey.asc \
 && gpg --verify composer.phar.asc composer.phar

RUN php composer.phar global config allow-plugins.uma/composer-psysh true \
 && php composer.phar global config bin-dir /usr/local/bin \
 && php composer.phar global config minimum-stability dev \
 && php composer.phar global config prefer-stable true \
 && php composer.phar global require --prefer-dist \
    composer/composer \
    d11wtq/boris \
    deployer/deployer \
    friendsofphp/php-cs-fixer \
    phing/phing \
    phploc/phploc \
    phpmetrics/phpmetrics \
    phpunit/phpunit \
    qossmic/deptrac-shim \
    uma/composer-psysh \
 && rm -rf ${COMPOSER_HOME}/.htaccess ${COMPOSER_HOME}/cache


FROM 1maa/php:7.3

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_HOME=/opt/composer

COPY etc /etc/php

COPY --from=0 ${COMPOSER_HOME} ${COMPOSER_HOME}
COPY --from=0 /usr/local/bin /usr/local/bin

RUN apk add --no-cache git
