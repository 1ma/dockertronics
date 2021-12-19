FROM postgres:14-alpine

ENV PGTAP_VERSION 1.2.0
ENV POSTGIS_VERSION 3.2.0

WORKDIR /tmp

ADD https://github.com/theory/pgtap/archive/refs/tags/v${PGTAP_VERSION}.tar.gz         pgtap.tar.gz
ADD https://download.osgeo.org/postgis/source/postgis-${POSTGIS_VERSION}.tar.gz        postgis.tar.gz
ADD https://github.com/gavinwahl/postgres-json-schema/archive/refs/heads/master.tar.gz postgres-json-schema.tar.gz

RUN echo "@edge-testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk --no-cache add \
    build-base \
    clang-dev \
    geos-dev@edge-testing \
    gdal-dev@edge-testing \
    json-c-dev \
    libxml2-dev \
    llvm12 \
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

RUN sed -e "s@#shared_buffers = 32MB@shared_buffers = 2GB@" \
        -e "s@#work_mem = 4MB@work_mem = 128MB@" \
        -e "s@#maintenance_work_mem = 64MB@maintenance_work_mem = 512MB@" \
        -e "s@#effective_io_concurrency = 1@effective_io_concurrency = 2@" \
        -e "s@#random_page_cost = 4.0@random_page_cost = 1.0@" \
        -e "s@#log_statement = 'none'@log_statement = 'all'@" \
        /usr/local/share/postgresql/postgresql.conf.sample > /etc/postgresql.conf \
 && chown postgres:postgres /etc/postgresql.conf \
 && echo "@edge-testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk --no-cache add \
    build-base \
    geos@edge-testing \
    gdal@edge-testing \
    json-c \
    libxml2 \
    perl-dev \
    proj@edge-testing \
    protobuf-c \
 && cpan TAP::Parser::SourceHandler::pgTAP \
 && apk del --no-cache -r build-base \
 && rm -rf \
    /root/.cpan \
    /usr/share/gdal \
    /usr/share/proj

CMD ["postgres", "-c", "config_file=/etc/postgresql.conf"]
