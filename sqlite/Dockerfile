FROM 1maa/alpine:3.10

# References:
#   https://www.sqlite.org/howtocompile.html
#   https://www.sqlite.org/compile.html

ENV SQLITE_VERSION=3280000

RUN cd ~ \
 && apk add --no-cache \
    build-base \
    readline-dev \
    unzip \
 && wget https://www.sqlite.org/2019/sqlite-amalgamation-${SQLITE_VERSION}.zip \
 && unzip sqlite-amalgamation-${SQLITE_VERSION}.zip \
 && cd sqlite-amalgamation-${SQLITE_VERSION} \
 && gcc \
    -DHAVE_READLINE \
    -DSQLITE_DEFAULT_MEMSTATUS=0 \
    -DSQLITE_OMIT_DEPRECATED \
    -DSQLITE_OMIT_LOAD_EXTENSION \
    -DSQLITE_THREADSAFE=0 \
    -DSQLITE_USE_ALLOCA \

    shell.c \
    sqlite3.c \

    -O3 \
    -s \
    -v \

    -lreadline \

    -o /usr/bin/sqlite3


FROM 1maa/alpine:3.10

COPY --from=0 /usr/bin/sqlite3 /usr/bin/sqlite3

RUN apk add --no-cache \
    readline

CMD ["/usr/bin/sqlite3"]
