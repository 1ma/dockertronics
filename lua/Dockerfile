FROM 1maa/alpine:3.10

ENV LUA_VERSION 5.3.5

WORKDIR /tmp

RUN apk add --no-cache \
    build-base \
    ncurses-static \
    readline-dev \
    upx \
 && wget -q https://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz \
 && tar zxf lua-${LUA_VERSION}.tar.gz \
 && cd lua-${LUA_VERSION} \
 && sed -i 's@-O2@@' src/Makefile \
 && sed -i 's@-DLUA_COMPAT_5_2@@' src/Makefile \
 && make linux \
    MYCFLAGS="-O3 -march=x86-64" \
    MYLDFLAGS="-s -static" \
    MYLIBS="-lncursesw" \
 && upx --lzma src/lua src/luac \
 && make test \
 && make install


FROM scratch

COPY --from=0 /etc/terminfo   /etc/terminfo
COPY --from=0 /usr/local/bin/ /

CMD ["/lua"]
