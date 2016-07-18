## 1ma's PHP images repository


### Flavors

* 1maa/php-cli
* 1maa/php-apa
* 1maa/php-fpm
* 1maa/php-sdk


-- TODO: rewrite details --
### 5.6/7.0

* PHP CLI available
* PHP FPM daemon listening on port 9000
* Has common PHP extensions (by "common" I mean the ones I've needed at least once in my life)


### 5.6-dev/7.0-dev

* Built on top of 1maa/php
* XDebug is enabled, with shell aliases to turn it on and off at will (xdebon and xdeboff respectively)
* FPM worker processes run as root to avoid silly permission issues on OS X macheens
* OpenSSH server is listening on port 22, accessible with user ```root``` and password ```root``` (enables PHPStorm XDebug integration)
* Toolbelt installed at /usr/local/bin with the following utilities:
    - Behat 3.1.0
    - Boris REPL 1.0.10
    - Composer 1.2.0-RC
    - Phing 2.14.0
    - PHP-CS-Fixer 1.11.2
    - PHPUnit 5.4.6
    - Symfony installer 1.5.1


### 5.6-sdk/7.0-sdk

* Also built on top of 1maa/php
* Comes with php5/7-pear, php5/7-dev, autoconf and the alpine-sdk
* Its primary purpose is acting as a building environment for PHP extensions which might not be in the official Alpine repositories (such as libsodium in the PHP5 branch)
