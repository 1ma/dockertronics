FROM 1maa/alpine:3.10

# References:
#   https://www.sqlite.org/howtocompile.html
#   https://www.sqlite.org/compile.html

ENV SQLITE_VERSION=3290000

WORKDIR /tmp

RUN apk add --no-cache \
    build-base \
    ncurses-static \
    readline-dev \
    unzip \
    upx \
 && wget https://www.sqlite.org/2019/sqlite-amalgamation-${SQLITE_VERSION}.zip \
 && unzip sqlite-amalgamation-${SQLITE_VERSION}.zip \
 && cd sqlite-amalgamation-${SQLITE_VERSION} \
 && gcc \
    -DHAVE_READLINE \
    -DSQLITE_DEFAULT_MEMSTATUS=0 \
    -DSQLITE_DQS=0 \
    -DSQLITE_OMIT_DEPRECATED \
    -DSQLITE_OMIT_LOAD_EXTENSION \
    -DSQLITE_THREADSAFE=0 \
    -DSQLITE_USE_ALLOCA \
    shell.c \
    sqlite3.c \
    -O3 \
    -s \
    -static \
    -v \
    -lreadline \
    -lncursesw \
    -o /tmp/sqlite3 \
  && upx --lzma /tmp/sqlite3


FROM busybox

WORKDIR /root

COPY --from=0 /etc/terminfo ./etc/terminfo
COPY --from=0 /tmp/sqlite3  ./sqlite3


FROM scratch

COPY --from=1 /root /

CMD ["/sqlite3"]
