#!/usr/bin/env ash

openssl req -x509 -nodes -days 3650 -newkey ${ALGO}:${BITS} -keyout /tmp/${FQDN}.key -out /tmp/${FQDN}.crt -subj "/CN=*.${FQDN}"
