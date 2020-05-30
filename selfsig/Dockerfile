FROM 1maa/alpine:3.12

ENV ALGO rsa
ENV BITS 4096
ENV FQDN example.com

RUN apk add --no-cache libressl

CMD openssl req -x509 -nodes -days 3650 -newkey ${ALGO}:${BITS} -keyout /tmp/${FQDN}.key -out /tmp/${FQDN}.crt -subj "/CN=*.${FQDN}"
