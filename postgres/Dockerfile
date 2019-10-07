FROM postgres:12-alpine

ENV PGTAP_VERSION v1.0.0
ENV POSTGIS_VERSION 2.5.3

RUN echo "@edge-testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk --no-cache add \
    build-base \
    geos-dev@edge-testing \
    gdal-dev@edge-testing \
    git \
    json-c-dev \
    libxml2-dev \
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


FROM postgres:12-alpine

COPY --from=0 /usr/local/lib/postgresql/postgis-2.5.so                    /usr/local/lib/postgresql/postgis-2.5.so
COPY --from=0 /usr/local/lib/postgresql/postgis_topology-2.5.so           /usr/local/lib/postgresql/postgis_topology-2.5.so
COPY --from=0 /usr/local/lib/postgresql/rtpostgis-2.5.so                  /usr/local/lib/postgresql/rtpostgis-2.5.so
COPY --from=0 /usr/local/share/postgresql/extension/pgtap*                /usr/local/share/postgresql/extension/
COPY --from=0 /usr/local/share/postgresql/extension/postgis*              /usr/local/share/postgresql/extension/
COPY --from=0 /usr/local/share/postgresql/extension/postgres-json-schema* /usr/local/share/postgresql/extension/
COPY postgresql.conf /etc/postgresql.conf

RUN chown postgres:postgres /etc/postgresql.conf \
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
