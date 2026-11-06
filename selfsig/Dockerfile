FROM alpine:3.24@sha256:3f4d6b32e26703c6082839234f43769d5046b3ac7c910033911d1e71d8cd630a

ENV ALGO=rsa
ENV BITS=4096
ENV FQDN=example.com

RUN apk add --no-cache openssl

COPY gencert.sh /opt/gencert.sh

CMD ["/opt/gencert.sh"]
