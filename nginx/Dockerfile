FROM alpine:3.6

ENV NGINX_VERSION 1.13.5

RUN apk add -U \
    alpine-sdk \
    curl \
    geoip-dev \
    libressl-dev \
    pcre-dev \
    zlib-dev \
 && curl -LOsS https://github.com/nginx/nginx/archive/release-${NGINX_VERSION}.tar.gz \
 && tar zxof release-${NGINX_VERSION}.tar.gz \
 && cd nginx-release-${NGINX_VERSION} \
 && sed -i 's@NGX_GCC_OPT="-O"@@'                       auto/cc/gcc \
 && sed -i 's@CFLAGS="$CFLAGS ${NGX_GCC_OPT:--O} -W"@@' auto/cc/gcc \
 && sed -i 's@CFLAGS="$CFLAGS -g"@@'                    auto/cc/gcc \
 && ./auto/configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --modules-path=/usr/lib/nginx/modules \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx_error.log \
    --http-log-path=/var/log/nginx_access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \

    --with-threads \

#    --with-file-aio \

    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_realip_module \
    --with-http_geoip_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_auth_request_module \

    --with-stream \
    --with-stream_ssl_module \
    --with-stream_realip_module \
    --with-stream_geoip_module \
    --with-stream_ssl_preread_module \

    --with-cc-opt="-static -O3 -march=x86-64" \
    --with-ld-opt="-static" \

    --with-debug \
 && make \
 && make install \
 && strip /usr/sbin/nginx


FROM 1maa/alpine:3.6

COPY --from=0 /etc/nginx      /etc/nginx
COPY --from=0 /usr/sbin/nginx /usr/sbin/nginx

EXPOSE 80 443

STOPSIGNAL SIGTERM

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
