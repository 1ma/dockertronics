FROM alpine:3.8

# References:
#   https://www.sqlite.org/howtocompile.html
#   https://www.sqlite.org/compile.html

ENV SQLITE_VERSION=3260000

RUN cd ~ \
 && apk add --no-cache \
    build-base \
    unzip \
 && wget https://www.sqlite.org/2018/sqlite-amalgamation-${SQLITE_VERSION}.zip \
 && unzip sqlite-amalgamation-${SQLITE_VERSION}.zip \
 && cd sqlite-amalgamation-${SQLITE_VERSION} \
 && gcc \
    -DSQLITE_DEFAULT_MEMSTATUS=0 \
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

    -o /usr/bin/sqlite3


FROM alpine:3.8

COPY --from=0 /usr/bin/sqlite3 /usr/bin/sqlite3

CMD ["/usr/bin/sqlite3"]
