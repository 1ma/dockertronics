FROM postgres:11-alpine

ENV PGTAP_VERSION v1.0.0
ENV POSTGIS_VERSION 2.5.2

RUN echo "@edge-main http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
 && echo "@edge-testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk --no-cache add \
    build-base \
    geos-dev@edge-testing \
    gdal-dev@edge-testing \
    git \
    json-c-dev@edge-main \
    libxml2-dev \
    perl \
    proj-dev@edge-testing \
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
 && git clone https://github.com/gavinwahl/postgres-json-schema \
 && cd postgres-json-schema \
 && make install


FROM postgres:11-alpine

COPY --from=0 /usr/local/lib/postgresql/postgis-2.5.so                    /usr/local/lib/postgresql/postgis-2.5.so
COPY --from=0 /usr/local/lib/postgresql/postgis_topology-2.5.so           /usr/local/lib/postgresql/postgis_topology-2.5.so
COPY --from=0 /usr/local/lib/postgresql/rtpostgis-2.5.so                  /usr/local/lib/postgresql/rtpostgis-2.5.so
COPY --from=0 /usr/local/share/postgresql/extension/pgtap*                /usr/local/share/postgresql/extension/
COPY --from=0 /usr/local/share/postgresql/extension/postgis*              /usr/local/share/postgresql/extension/
COPY --from=0 /usr/local/share/postgresql/extension/postgres-json-schema* /usr/local/share/postgresql/extension/
COPY postgresql.conf /etc/postgresql.conf

RUN chown postgres:postgres /etc/postgresql.conf \
 && echo "@edge-main http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
 && echo "@edge-testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk --no-cache add \
    build-base \
    geos@edge-testing \
    gdal@edge-testing \
    json-c@edge-main \
    libxml2 \
    perl-dev \
    proj@edge-testing \
 && cpan TAP::Parser::SourceHandler::pgTAP \
 && apk del --no-cache -r build-base \
 && rm -rf \
    /root/.cpan \
    /usr/share/gdal \
    /usr/share/proj

CMD ["postgres", "-c", "config_file=/etc/postgresql.conf"]
