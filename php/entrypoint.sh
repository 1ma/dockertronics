#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- /usr/local/sbin/php-fpm --nodaemonize "$@"
fi

exec "$@"
