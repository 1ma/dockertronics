#!/usr/bin/env sh

/usr/local/pgsql/bin/initdb --locale=${LANG} --data-checksums -D /var/lib/postgres/data

/usr/local/pgsql/bin/postgres -D /var/lib/postgres/data
