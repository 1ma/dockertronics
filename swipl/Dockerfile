FROM alpine:3.11

ENV SWIPL_VERSION 8.1.27

WORKDIR /tmp

ADD https://www.swi-prolog.org/download/devel/src/swipl-${SWIPL_VERSION}.tar.gz .

RUN apk add --no-cache \
    build-base \
    cmake \
    readline-dev \
    zlib-dev \
 && tar zxf swipl-${SWIPL_VERSION}.tar.gz \
 && mkdir swipl-${SWIPL_VERSION}/build

WORKDIR /tmp/swipl-${SWIPL_VERSION}/build

RUN cmake -DINSTALL_DOCUMENTATION=OFF -DCMAKE_INSTALL_PREFIX=/usr/local ..

RUN make -j$(nproc)

RUN make install


FROM alpine:3.11

COPY --from=0 /usr/local /usr/local

RUN apk add --no-cache \
    readline

CMD ["/usr/local/bin/swipl"]
