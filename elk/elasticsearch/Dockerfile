FROM alpine:3.6

ENV VERSION 5.6.3

RUN apk add --no-cache curl \
 && curl -LO https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${VERSION}.tar.gz \
 && tar zxf elasticsearch-${VERSION}.tar.gz \
 && mv elasticsearch-${VERSION} /tmp/elasticsearch


FROM 1maa/alpine:3.6

COPY --from=0 /tmp/elasticsearch /elk/elasticsearch
COPY          elasticsearch.yml  /elk/elasticsearch/config/elasticsearch.yml

RUN apk add --no-cache \
    bash \
    openjdk8-jre \
 && adduser -S -D -H -h /dev/null -s /sbin/nologin -G daemon elk \
 && chown -R elk:daemon /elk

USER elk

EXPOSE 9200 9300

CMD ["bash", "/elk/elasticsearch/bin/elasticsearch"]
