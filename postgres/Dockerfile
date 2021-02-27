FROM postgres:13-alpine

ENV PGTAP_VERSION v1.1.0
ENV POSTGIS_VERSION 3.1.1

RUN echo "@edge-testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk --no-cache add \
    build-base \
    clang-dev \
    geos-dev@edge-testing \
    gdal-dev@edge-testing \
    git \
    json-c-dev \
    libxml2-dev \
    llvm10 \
    perl \
    proj-dev@edge-testing \
    protobuf-c-dev \
 && wget -q https://download.osgeo.org/postgis/source/postgis-${POSTGIS_VERSION}.tar.gz \
 && tar zxf postgis-${POSTGIS_VERSION}.tar.gz \
 && cd postgis-${POSTGIS_VERSION} \
 && make \
 && make install \
 && git clone https://github.com/theory/pgtap \
 && cd pgtap \
 && git checkout ${PGTAP_VERSION} \
 && make \
 && make install \
 && cd .. \
 && git clone --depth=1 https://github.com/gavinwahl/postgres-json-schema \
 && cd postgres-json-schema \
 && make install


FROM postgres:13-alpine

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
 && echo "@edge-testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
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
