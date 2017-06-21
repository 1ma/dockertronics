FROM 1maa/alpine:3.6

ENV ALGO rsa
ENV BITS 4096
ENV FQDN example.com

RUN apk add --no-cache libressl

CMD openssl req -nodes -newkey ${ALGO}:${BITS} -keyout /tmp/${FQDN}.key -out /tmp/${FQDN}.crt -subj "/CN=${FQDN}"
