FROM busybox

COPY https-repositories .

RUN chmod 644 https-repositories


FROM alpine:3.17

# list of mirrors: https://mirrors.alpinelinux.org/
COPY --from=0 https-repositories /etc/apk/repositories

RUN apk upgrade --no-cache \
 && apk add --no-cache --upgrade \
    tini

ENTRYPOINT ["/sbin/tini", "--"]
