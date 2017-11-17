FROM postgres:10-alpine

ENV PGTAP_VERSION v0.98.0

RUN apk -U add \
    alpine-sdk \
    perl \
 && git clone https://github.com/theory/pgtap \
 && cd pgtap \
 && git checkout ${PGTAP_VERSION} \
 && make \
 && make install


FROM postgres:10-alpine

COPY --from=0 /usr/local/share/postgresql/extension/pgtap* /usr/local/share/postgresql/extension/

RUN apk -U add \
    build-base \
    perl-dev \
 && cpan TAP::Parser::SourceHandler::pgTAP \
 && apk del -r build-base
