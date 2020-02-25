FROM 1maa/alpine:3.11

ENV RR_VERSION=1.6.2

WORKDIR /tmp

ADD https://github.com/spiral/roadrunner/releases/download/v${RR_VERSION}/roadrunner-${RR_VERSION}-linux-amd64.tar.gz .

RUN tar zxf roadrunner-${RR_VERSION}-linux-amd64.tar.gz \
 && mv roadrunner-${RR_VERSION}-linux-amd64/rr /usr/local/bin/rr \
 && apk add --no-cache \
    upx \
 && upx --lzma /usr/local/bin/rr


FROM 1maa/php:7.4

COPY --from=0 /usr/local/bin/rr /usr/local/bin/rr

RUN ln -s /etc/php/mods-available/xdebug.ini /etc/php/cli/conf.d/xdebug.ini

EXPOSE 80
EXPOSE 443

CMD ["/usr/local/bin/rr", "serve"]
