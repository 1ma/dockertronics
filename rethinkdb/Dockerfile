FROM 1maa/alpine:edge

RUN apk add --no-cache rethinkdb

VOLUME ["/data"]

WORKDIR /data

CMD ["rethinkdb", "--bind", "all"]

EXPOSE 28015 29015 8080
