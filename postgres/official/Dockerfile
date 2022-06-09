FROM postgres:14-alpine

ARG PGTAP_VERSION=1.2.0
ARG POSTGIS_VERSION=3.2.1

WORKDIR /tmp

ADD https://github.com/theory/pgtap/archive/refs/tags/v${PGTAP_VERSION}.tar.gz         pgtap.tar.gz
ADD https://download.osgeo.org/postgis/source/postgis-${POSTGIS_VERSION}.tar.gz        postgis.tar.gz
ADD https://github.com/gavinwahl/postgres-json-schema/archive/refs/heads/master.tar.gz postgres-json-schema.tar.gz

RUN echo "@edge-testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk --no-cache add \
    build-base \
    clang-dev \
    gdal-dev@edge-testing \
    geos-dev@edge-testing \
    json-c-dev \
    libxml2-dev \
    llvm13 \
    perl \
    proj-dev@edge-testing \
    protobuf-c-dev \
 && tar zxf postgis.tar.gz \
 && cd postgis-${POSTGIS_VERSION} \
 && make -j$(nproc) \
 && make install

RUN tar zxf pgtap.tar.gz \
 && cd pgtap-${PGTAP_VERSION} \
 && make -j$(nproc) \
 && make install

RUN tar zxf postgres-json-schema.tar.gz \
 && cd postgres-json-schema-master \
 && make install


FROM postgres:14-alpine

COPY --from=0 /usr/local/lib/postgresql/bitcode/postgis*                  /usr/local/lib/postgresql/bitcode/
COPY --from=0 /usr/local/lib/postgresql/postgis*                          /usr/local/lib/postgresql/
COPY --from=0 /usr/local/share/postgresql/extension/pgtap*                /usr/local/share/postgresql/extension/
COPY --from=0 /usr/local/share/postgresql/extension/postgis*              /usr/local/share/postgresql/extension/
COPY --from=0 /usr/local/share/postgresql/extension/postgres-json-schema* /usr/local/share/postgresql/extension/

RUN echo "@edge-testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk --no-cache add \
    build-base \
    gdal@edge-testing \
    geos@edge-testing \
    json-c \
    libxml2 \
    musl-locales \
    perl-dev \
    proj@edge-testing \
    protobuf-c \
 && cpan TAP::Parser::SourceHandler::pgTAP \
 && apk del --no-cache -r build-base \
 && rm -rf \
    /root/.cpan \
    /usr/share/gdal \
    /usr/share/proj

CMD ["-c", "checkpoint_completion_target=0.9", \
     "-c", "default_statistics_target=100",    \
     "-c", "effective_cache_size=4GB",         \
     "-c", "effective_io_concurrency=200",     \
     "-c", "log_statement=all",                \
     "-c", "maintenance_work_mem=1GB",         \
     "-c", "max_connections=20",               \
     "-c", "max_wal_size=2GB",                 \
     "-c", "min_wal_size=100MB",               \
     "-c", "random_page_cost=1.1",             \
     "-c", "shared_buffers=1GB",               \
     "-c", "wal_buffers=16MB",                 \
     "-c", "work_mem=21845kB"                  \
]
