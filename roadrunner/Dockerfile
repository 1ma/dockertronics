FROM golang:alpine

ENV RR_VERSION=1.8.1

WORKDIR /tmp

ADD https://github.com/spiral/roadrunner/archive/v${RR_VERSION}.zip .

RUN apk add --no-cache \
    file \
    upx \
 && unzip v${RR_VERSION}.zip \
 && cd roadrunner-${RR_VERSION} \
 && CGO_ENABLED=0 go build \
    -ldflags "-X github.com/spiral/roadrunner/cmd/rr/cmd.Version=${RR_VERSION} -X github.com/spiral/roadrunner/cmd/rr/cmd.BuildTime=$(date +%FT%T%z) -s -w -d" \
    -o /usr/local/bin/rr cmd/rr/main.go \
 && file /usr/local/bin/rr \
 && upx --lzma /usr/local/bin/rr \
 && file /usr/local/bin/rr


FROM 1maa/php:7.4

COPY --from=0 /usr/local/bin/rr /usr/local/bin/rr

RUN ln -s /etc/php/mods-available/xdebug.ini /etc/php/cli/conf.d/xdebug.ini

EXPOSE 80
EXPOSE 443

CMD ["/usr/local/bin/rr", "serve"]
