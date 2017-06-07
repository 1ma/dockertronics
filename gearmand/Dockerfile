FROM 1maa/alpine:3.6

RUN apk add --no-cache \
    gearmand@edge-testing \
    libevent@edge-main \
    libressl@edge-main

EXPOSE 4730

CMD ["/usr/sbin/gearmand", "--user", "gearman", "--log-file", "stderr", "--verbose", "INFO"]
