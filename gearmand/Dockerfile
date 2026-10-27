ARG PUBLIC_ALPINE_IMAGE="sha256:0000000000000000000000000000000000000000000000000000000000000000"

FROM alpine@${PUBLIC_ALPINE_IMAGE} AS build

ARG GEARMAND_VERSION=2.2.0

ENV CFLAGS="-g0 -Os"
ENV CXXFLAGS="-g0 -Os"
ENV LDFLAGS="-Wl,--as-needed -Wl,--strip-all"

WORKDIR /tmp

ADD https://github.com/gearman/gearmand/releases/download/${GEARMAND_VERSION}/gearmand-${GEARMAND_VERSION}.tar.gz .
ADD https://github.com/gearman/gearmand/releases/download/${GEARMAND_VERSION}/gearmand-${GEARMAND_VERSION}.tar.gz.asc .

COPY esabol.asc .

RUN apk add --no-cache \
    gnupg \
 && gpg --import esabol.asc \
 && gpg --verify gearmand-${GEARMAND_VERSION}.tar.gz.asc gearmand-${GEARMAND_VERSION}.tar.gz

RUN tar zxf gearmand-${GEARMAND_VERSION}.tar.gz \
 && chown -R root:root ./*

RUN apk add --no-cache \
    boost-dev \
    build-base \
    gperf \
    hiredis-dev \
    libevent-dev \
    libmemcached-dev \
    libpq-dev \
    mariadb-connector-c-dev \
    openssl-dev \
    sqlite-dev \
    util-linux-dev

WORKDIR /tmp/gearmand-${GEARMAND_VERSION}

RUN ./configure \
    --disable-dependency-tracking \
    --disable-libdrizzle \
    --disable-libtokyocabinet \
    --disable-static \
    --enable-ssl \
    ax_cv_check_cflags__Werror__g=no \
    ax_cv_check_cflags__Werror__O2=no \
    ax_cv_check_cxxflags__Werror__g=no \
    ax_cv_check_cxxflags__Werror__O2=no \
 && make -j$(nproc) \
 && make install


FROM alpine@${PUBLIC_ALPINE_IMAGE} AS final

COPY --from=build /usr/local /usr/local
COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

RUN apk add --no-cache \
    boost-program_options \
    hiredis \
    libevent \
    libgcc \
    libmemcached-libs \
    libpq \
    libstdc++ \
    libuuid \
    mandoc \
    mariadb-connector-c \
    sqlite-libs \
 && adduser -D -H -S -s /sbin/nologin gearman

USER gearman

EXPOSE 4730

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/local/sbin/gearmand", "--log-file", "stderr"]
