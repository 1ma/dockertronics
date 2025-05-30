FROM alpine:3.22

ENV ALGO=rsa
ENV BITS=4096
ENV FQDN=example.com

RUN apk add --no-cache openssl

COPY gencert.sh /opt/gencert.sh

CMD ["/opt/gencert.sh"]
