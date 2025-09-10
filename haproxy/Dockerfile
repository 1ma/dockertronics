FROM alpine:3.22

ARG HAPROXY_VERSION=3.2.8

WORKDIR /tmp

ADD https://www.haproxy.org/download/3.2/src/haproxy-${HAPROXY_VERSION}.tar.gz .

RUN apk add --no-cache \
    build-base \
    linux-headers \
    lua5.4-dev \
    openssl-dev \
    pcre2-dev \
    pcre2-static \
    upx \
    zlib-dev \
 && tar zxf haproxy-${HAPROXY_VERSION}.tar.gz \
 && make -C haproxy-${HAPROXY_VERSION} all -j$(nproc) \
    CPU_CFLAGS="-Os -march=x86-64" \
    DEBUG_CFLAGS= \
    LDFLAGS="-s" \
    LUA_INC="/usr/include/lua5.4" \
    LUA_LIB="/usr/lib/lua5.4" \
    TARGET=linux-glibc \
    USE_BACKTRACE= \
    USE_GETADDRINFO=1 \
    USE_LUA=1 \
    USE_OPENSSL=1 \
    USE_PCRE2=1 \
    USE_PCRE2_JIT=1 \
    USE_PROMEX=1 \
    USE_REGPARM=1 \
    USE_STATIC_PCRE2=1 \
    USE_ZLIB=1 \
    V=1 \
 && upx --lzma haproxy-${HAPROXY_VERSION}/haproxy \
 && mv haproxy-${HAPROXY_VERSION}/haproxy .


FROM 1maa/alpine:latest

COPY config /etc/haproxy

COPY --from=0 /tmp/haproxy /usr/sbin/haproxy

RUN apk add --no-cache \
    libssl3 \
    lua5.4-libs

STOPSIGNAL SIGUSR1

EXPOSE 80

CMD ["/usr/sbin/haproxy", "-W", "-db", "-f", "/etc/haproxy/haproxy.cfg"]
