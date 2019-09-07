FROM 1maa/alpine:3.10

ENV HAPROXY_VERSION=2.0.5

WORKDIR /tmp

RUN apk add --no-cache \
    build-base \
    linux-headers \
    openssl-dev \
    upx \
    zlib-dev \
 && wget -q https://www.haproxy.org/download/2.0/src/haproxy-${HAPROXY_VERSION}.tar.gz \
 && tar zxf haproxy-${HAPROXY_VERSION}.tar.gz \
 && cd haproxy-${HAPROXY_VERSION} \
 && make all -j$(nproc) \
    CPU_CFLAGS="-O3 -march=x86-64" \
    DEBUG_CFLAGS= \
    EXTRA_OBJS="contrib/prometheus-exporter/service-prometheus.o" \
    LDFLAGS="-s -static" \
    TARGET=linux-glibc \
    USE_OPENSSL=1 \
    USE_ZLIB=1 \
 && upx --lzma haproxy \
 && mv haproxy ..

FROM busybox

COPY --from=0 /tmp/haproxy /root/haproxy

RUN mkdir /root/etc \
 && touch /root/etc/haproxy.cfg \
 && echo "nobody:x:65534:65534:nobody:/:/sbin/nologin" > /root/etc/passwd


FROM scratch

COPY --from=1 /root /

USER nobody

STOPSIGNAL SIGUSR1

CMD ["/haproxy", "-W", "-db", "-f", "/etc/haproxy.cfg"]
