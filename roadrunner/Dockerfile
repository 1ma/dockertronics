FROM alpine:3.8

ENV RR_VERSION=1.2.4

RUN apk add --no-cache curl \
 && cd /tmp \
 && curl -OL https://github.com/spiral/roadrunner/releases/download/v${RR_VERSION}/roadrunner-${RR_VERSION}-linux-amd64.tar.gz \
 && tar zxvf roadrunner-${RR_VERSION}-linux-amd64.tar.gz \
 && mv roadrunner-${RR_VERSION}-linux-amd64/rr .


FROM 1maa/php-dev:7.2

COPY --from=0 /tmp/rr /usr/local/bin/rr

RUN ln -s /etc/php/mods-available/xdebug.ini /etc/php/cli/conf.d/xdebug.ini

EXPOSE 80
EXPOSE 443

CMD ["/usr/local/bin/rr", "serve"]
