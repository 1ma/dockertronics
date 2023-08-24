FROM alpine:latest AS builder

ARG POSTGRES_VERSION=16beta3

WORKDIR /tmp

ADD https://ftp.postgresql.org/pub/source/v${POSTGRES_VERSION}/postgresql-${POSTGRES_VERSION}.tar.gz .

RUN apk add --no-cache \
    build-base \
    libxml2-dev \
    libxslt-dev \
    linux-headers \
    openssl-dev \
    readline-dev \
    zlib-dev \
 && tar zxof postgresql-${POSTGRES_VERSION}.tar.gz \
 && cd postgresql-${POSTGRES_VERSION} \
 && ./configure \
    CFLAGS="-Os -march=x86-64" \
    LDFLAGS="-s" \
    --prefix=/tmp/pgsql \
    --with-libxml \
    --with-libxslt \
    --with-ssl=openssl \
    --without-icu

RUN make -C postgresql-${POSTGRES_VERSION} world -j$(nproc) \
 && make -C postgresql-${POSTGRES_VERSION} install-world \
 && rm -rf /tmp/pgsql/share/doc \
 && rm -rf /tmp/pgsql/share/man


FROM 1maa/alpine:latest AS postgis

ARG PGTAP_VERSION=1.3.0
ARG POSTGIS_VERSION=3.4.0

WORKDIR /tmp

COPY --from=builder /tmp/pgsql /usr/local

ADD https://download.osgeo.org/postgis/source/postgis-${POSTGIS_VERSION}.tar.gz .
ADD https://github.com/theory/pgtap/archive/refs/tags/v${PGTAP_VERSION}.tar.gz .

RUN apk --no-cache add \
    build-base \
    clang-dev \
    gdal-dev \
    geos-dev \
    json-c-dev \
    libxml2-dev \
    llvm16 \
    perl \
    proj-dev \
    protobuf-c-dev \
 && tar zxf postgis-${POSTGIS_VERSION}.tar.gz \
 && cd postgis-${POSTGIS_VERSION} \
 && ./configure \
    CFLAGS="-Os -march=x86-64" \
    LDFLAGS="-s" \
    --enable-lto

RUN make -C postgis-${POSTGIS_VERSION} -j$(nproc) \
 && make -C postgis-${POSTGIS_VERSION} install

RUN tar zxf v${PGTAP_VERSION}.tar.gz \
 && make -C pgtap-${PGTAP_VERSION} -j$(nproc) \
 && make -C pgtap-${PGTAP_VERSION} install

FROM alpine:latest AS cleanup

WORKDIR /tmp

COPY --from=postgis /usr/local/share/extension /tmp

RUN ls -1 | grep -v -E 'pgtap|postgis' | xargs rm -f


FROM 1maa/alpine:latest

ENV LANG=en_US.UTF-8
ENV POSTGRES_DB=postgres
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres

COPY --from=builder /tmp/pgsql                           /usr/local
COPY --from=postgis /usr/local/bin/pgsql2shp             /usr/local/bin
COPY --from=postgis /usr/local/bin/pgtopo_export         /usr/local/bin
COPY --from=postgis /usr/local/bin/pgtopo_import         /usr/local/bin
COPY --from=postgis /usr/local/bin/postgis               /usr/local/bin
COPY --from=postgis /usr/local/bin/postgis_restore       /usr/local/bin
COPY --from=postgis /usr/local/bin/raster2pgsql          /usr/local/bin
COPY --from=postgis /usr/local/bin/shp2pgsql             /usr/local/bin
COPY --from=postgis /usr/local/lib/postgis-3.so          /usr/local/lib
COPY --from=postgis /usr/local/lib/postgis_raster-3.so   /usr/local/lib
COPY --from=postgis /usr/local/lib/postgis_topology-3.so /usr/local/lib
COPY --from=postgis /usr/local/share/contrib/postgis-3.4 /usr/local/share/contrib/postgis-3.4
COPY --from=cleanup /tmp                                 /usr/local/share/extension

COPY docker-entrypoint.sh /usr/local/bin

RUN apk add --no-cache \
    gdal \
    geos \
    json-c \
    libssl3 \
    libxml2 \
    libxslt \
    musl-locales \
    proj \
    protobuf-c \
    readline \
 && addgroup --system postgres \
 && adduser --system --disabled-password --home /var/lib/postgres --shell /bin/false --ingroup postgres postgres \
 && mkdir /var/lib/postgres/data /docker-entrypoint-initdb.d \
 && chown postgres:postgres /var/lib/postgres/data

USER postgres

VOLUME ["/var/lib/postgres/data"]

STOPSIGNAL SIGINT

EXPOSE 5432

CMD ["/usr/local/bin/docker-entrypoint.sh"]
