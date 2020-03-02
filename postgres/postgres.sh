#!/usr/bin/env sh

/usr/local/postgres/bin/initdb -k -D /var/lib/postgres/data

/usr/local/postgres/bin/postgres -D /var/lib/postgres/data
