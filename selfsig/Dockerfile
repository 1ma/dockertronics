FROM alpine:3.24@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a

ENV ALGO=rsa
ENV BITS=4096
ENV FQDN=example.com

RUN apk add --no-cache openssl

COPY gencert.sh /opt/gencert.sh

CMD ["/opt/gencert.sh"]
