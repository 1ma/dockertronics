FROM alpine:3.23

ARG LUA_VERSION=5.4.8

WORKDIR /tmp

RUN apk add --no-cache \
    build-base \
    file \
    ncurses-static \
    readline-dev \
    readline-static \
    upx \
 && wget -q https://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz \
 && tar zxf lua-${LUA_VERSION}.tar.gz \
 && cd lua-${LUA_VERSION} \
 && sed -i -e 's@-O2 @@' -e 's@-DLUA_COMPAT_5_3 @@' src/Makefile \
 && make linux-readline \
    MYCFLAGS="-Os" \
    MYLDFLAGS="-s -static" \
    MYLIBS="-lncursesw" \
 && file src/lua src/luac \
 && upx --lzma src/lua src/luac \
 && file src/lua src/luac \
 && make test \
 && make install


FROM busybox

WORKDIR /root

COPY --from=0 /etc/terminfo           ./etc/terminfo
COPY --from=0 /usr/local/bin          ./usr/bin
COPY --from=0 /usr/local/include      ./usr/include
COPY --from=0 /usr/local/lib/liblua.a ./usr/lib/liblua.a

RUN chown -R root:root .


FROM scratch

COPY --from=1 /root /

CMD ["/usr/bin/lua"]
