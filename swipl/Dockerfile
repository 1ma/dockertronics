FROM alpine:3.12

ENV SWIPL_VERSION 8.3.6

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

RUN cmake \
    -DBUILD_TESTING=OFF \
\
    -DCMAKE_BUILD_TYPE=MinSizeRel \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
\
    -DINSTALL_DOCUMENTATION=OFF \
    ..

RUN make -j$(nproc)

RUN make install


FROM alpine:3.12

COPY --from=0 /usr/local /usr/local

RUN apk add --no-cache \
    readline

CMD ["/usr/local/bin/swipl"]
