FROM 1maa/alpine:3.10

ENV HAPROXY_VERSION=2.0.10

WORKDIR /tmp

RUN apk add --no-cache \
    build-base \
    linux-headers \
    lua5.3-dev \
    openssl-dev \
    pcre2-dev \
    upx \
    zlib-dev \
 && wget -q https://www.haproxy.org/download/2.0/src/haproxy-${HAPROXY_VERSION}.tar.gz \
 && tar zxf haproxy-${HAPROXY_VERSION}.tar.gz \
 && cd haproxy-${HAPROXY_VERSION} \
 && make all -j$(nproc) \
    CPU_CFLAGS="-O3 -march=x86-64" \
    DEBUG_CFLAGS= \
    EXTRA_OBJS="contrib/prometheus-exporter/service-prometheus.o" \
    LDFLAGS="-s" \
    LUA_INC="/usr/include/lua5.3" \
    LUA_LIB="/usr/lib/lua5.3" \
    TARGET=linux-glibc \
    USE_GETADDRINFO=1 \
    USE_LUA=1 \
    USE_OPENSSL=1 \
    USE_PCRE2=1 \
    USE_PCRE2_JIT=1 \
    USE_REGPARM=1 \
    USE_STATIC_PCRE2=1 \
    USE_ZLIB=1 \
 && upx --lzma haproxy \
 && mv haproxy ..

FROM 1maa/alpine:3.10

COPY config /etc/haproxy

COPY --from=0 /tmp/haproxy /usr/sbin/haproxy

RUN apk add --no-cache \
    lua5.3-libs

STOPSIGNAL SIGUSR1

EXPOSE 80

CMD ["/usr/sbin/haproxy", "-W", "-db", "-f", "/etc/haproxy/haproxy.cfg"]
