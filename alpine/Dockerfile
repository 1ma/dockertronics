FROM alpine:3.8

RUN echo "@edge-main http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
 && echo "@edge-community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && echo "@edge-testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk add --no-cache --upgrade tini apk-tools@edge-main

ENTRYPOINT ["/sbin/tini", "--"]
