FROM golang:alpine

ENV RR_VERSION=v1.6.2

WORKDIR /tmp

RUN apk add --no-cache \
    git \
    upx \
 && git clone --branch=${RR_VERSION} --depth=1 https://github.com/spiral/roadrunner \
 && cd roadrunner \
 && CGO_ENABLED=0 go build -ldflags "-s -w -extldflags '-static'" -o /usr/local/bin/rr cmd/rr/main.go \
 && upx --lzma /usr/local/bin/rr


FROM 1maa/php:7.4

COPY --from=0 /usr/local/bin/rr /usr/local/bin/rr

RUN ln -s /etc/php/mods-available/xdebug.ini /etc/php/cli/conf.d/xdebug.ini

EXPOSE 80
EXPOSE 443

CMD ["/usr/local/bin/rr", "serve"]
