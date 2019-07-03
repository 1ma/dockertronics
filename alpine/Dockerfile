FROM busybox

COPY https-repositories .

RUN chmod 644 https-repositories


FROM alpine:3.10

# list of mirrors: https://github.com/alpinelinux/aports/blob/master/main/alpine-mirrors/mirrors.yaml
COPY --from=0 https-repositories /etc/apk/repositories

RUN apk add --no-cache --upgrade \
    apk-tools@edge-main \
    tini

ENTRYPOINT ["/sbin/tini", "--"]
