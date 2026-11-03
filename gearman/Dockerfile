FROM alpine:3.24@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a AS build

ARG GEARMAN_VERSION=2.2.0

ENV CFLAGS="-g0 -Os"
ENV CXXFLAGS="-g0 -Os"
ENV LDFLAGS="-Wl,--as-needed -Wl,--strip-all"

WORKDIR /tmp

ADD https://github.com/gearman/gearmand/releases/download/${GEARMAN_VERSION}/gearmand-${GEARMAN_VERSION}.tar.gz .
ADD https://github.com/gearman/gearmand/releases/download/${GEARMAN_VERSION}/gearmand-${GEARMAN_VERSION}.tar.gz.asc .

COPY esabol.asc .

RUN apk add --no-cache \
    gnupg \
 && gpg --import esabol.asc \
 && gpg --verify gearmand-${GEARMAN_VERSION}.tar.gz.asc gearmand-${GEARMAN_VERSION}.tar.gz

RUN tar zxf gearmand-${GEARMAN_VERSION}.tar.gz \
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

WORKDIR /tmp/gearmand-${GEARMAN_VERSION}

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


FROM alpine:3.24@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a AS final

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
