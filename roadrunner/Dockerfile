FROM golang:alpine

ENV RR_VERSION=2.9.1
ENV CGO_ENABLED=0

WORKDIR /tmp

ADD https://github.com/roadrunner-server/roadrunner/archive/v${RR_VERSION}.zip .

RUN apk add --no-cache \
    file \
    upx \
 && unzip v${RR_VERSION}.zip

WORKDIR /tmp/roadrunner-${RR_VERSION}

RUN go build \
    -trimpath \
    -ldflags "-X github.com/spiral/roadrunner-binary/v2/cli.Version=${RR_VERSION} -X github.com/spiral/roadrunner-binary/v2/cli.BuildTime=$(date +%FT%T%z) -s -w -d" \
    -o /tmp/rr \
    cmd/rr/main.go \
 && file /tmp/rr \
 && upx --lzma /tmp/rr \
 && file /tmp/rr


FROM 1maa/php:8.1

COPY --from=0 /tmp/rr /usr/local/bin/rr
COPY .rr.yaml .

RUN ln -s /etc/php/mods-available/xdebug.ini /etc/php/cli/conf.d/xdebug.ini

EXPOSE 80
EXPOSE 443

CMD ["/usr/local/bin/rr", "serve"]
