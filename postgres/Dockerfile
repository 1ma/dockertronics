FROM postgres:10-alpine

ENV PGTAP_VERSION v0.99.0

RUN apk --no-cache add \
    alpine-sdk \
    perl \
 && git clone https://github.com/theory/pgtap \
 && cd pgtap \
 && git checkout ${PGTAP_VERSION} \
 && make \
 && make install \
 && cd .. \
 && git clone https://github.com/gavinwahl/postgres-json-schema \
 && cd postgres-json-schema \
 && make install


FROM postgres:10-alpine

COPY --from=0 /usr/local/share/postgresql/extension/pgtap*                /usr/local/share/postgresql/extension/
COPY --from=0 /usr/local/share/postgresql/extension/postgres-json-schema* /usr/local/share/postgresql/extension/
COPY postgresql.conf /etc/postgresql.conf

RUN chown postgres:postgres /etc/postgresql.conf \
 && apk --no-cache add \
    build-base \
    perl-dev \
 && cpan TAP::Parser::SourceHandler::pgTAP \
 && apk del -r build-base

CMD ["postgres", "-c", "config_file=/etc/postgresql.conf"]
