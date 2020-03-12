FROM golang:alpine

ENV RR_VERSION=1.6.3

WORKDIR /tmp

RUN apk add --no-cache \
    file \
    git \
    upx \
 && git clone --branch=v${RR_VERSION} --depth=1 https://github.com/spiral/roadrunner \
 && cd roadrunner \
 && CGO_ENABLED=0 go build -ldflags "-X github.com/spiral/roadrunner/cmd/rr/cmd.Version=${RR_VERSION} -X github.com/spiral/roadrunner/cmd/rr/cmd.BuildTime=$(date +%FT%T%z) -s -w -d" -o /usr/local/bin/rr cmd/rr/main.go \
 && file /usr/local/bin/rr \
 && upx --lzma /usr/local/bin/rr \
 && file /usr/local/bin/rr


FROM 1maa/php:7.4

COPY --from=0 /usr/local/bin/rr /usr/local/bin/rr

RUN ln -s /etc/php/mods-available/xdebug.ini /etc/php/cli/conf.d/xdebug.ini

EXPOSE 80
EXPOSE 443

CMD ["/usr/local/bin/rr", "serve"]
