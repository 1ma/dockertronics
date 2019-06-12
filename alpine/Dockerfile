FROM alpine:3.9

# list of mirrors: https://github.com/alpinelinux/aports/blob/master/main/alpine-mirrors/mirrors.yaml
COPY https-repositories /etc/apk/repositories

RUN apk add --no-cache --upgrade \
    apk-tools@edge-main \
    tini

ENTRYPOINT ["/sbin/tini", "--"]
