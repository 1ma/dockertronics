FROM busybox

WORKDIR /tmp

ADD https://downloads.mysql.com/docs/sakila-db.tar.gz .

RUN tar zxf sakila-db.tar.gz


FROM 1maa/mysql:8.0

COPY --from=0 /tmp/sakila-db/sakila-schema.sql /docker-entrypoint-initdb.d/00-sakila-schema.sql
COPY --from=0 /tmp/sakila-db/sakila-data.sql   /docker-entrypoint-initdb.d/01-sakila-data.sql
