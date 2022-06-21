FROM alpine:latest AS builder

ENV PG_RELEASE=14.4

WORKDIR /tmp

ADD https://ftp.postgresql.org/pub/source/v${PG_RELEASE}/postgresql-${PG_RELEASE}.tar.gz .

RUN apk add --no-cache \
    build-base \
    libxml2-dev \
    libxslt-dev \
    linux-headers \
    openssl3-dev \
    readline-dev \
    zlib-dev \
 && tar zxof postgresql-${PG_RELEASE}.tar.gz \
 && cd postgresql-${PG_RELEASE} \
 && ./configure \
    CFLAGS="-Os -march=x86-64" \
    LDFLAGS="-s" \
    --with-libxml \
    --with-libxslt \
    --with-openssl

RUN cd postgresql-${PG_RELEASE} \
 && make world -j$(nproc)

RUN cd postgresql-${PG_RELEASE} \
 && make install-world \
 && rm -rf /usr/local/pgsql/share/doc \
 && rm -rf /usr/local/pgsql/share/man

COPY startup.sh /usr/local/pgsql/bin/startup.sh


FROM 1maa/alpine:latest

ENV LANG=en_US.UTF-8
ENV PATH=/usr/local/pgsql/bin:$PATH
ENV POSTGRES_DB=postgres
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres

COPY --from=builder /usr/local/pgsql /usr/local/pgsql

RUN apk add --no-cache \
    libssl3 \
    libxml2 \
    libxslt \
    musl-locales \
    readline \
 && addgroup --system postgres \
 && adduser --system --disabled-password --home /var/lib/postgres --shell /bin/false --ingroup postgres postgres \
 && mkdir /var/lib/postgres/data /docker-entrypoint-initdb.d \
 && chown postgres:postgres /var/lib/postgres/data

USER postgres

VOLUME ["/var/lib/postgres/data"]

STOPSIGNAL SIGINT

EXPOSE 5432

CMD ["/usr/local/pgsql/bin/startup.sh"]
