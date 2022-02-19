FROM alpine:latest AS build

ENV ERLANG_VERSION=25.0-rc1
ENV CFLAGS="-Os -march=x86-64"
ENV LDFLAGS="-s"

# https://www.erlang.org/docs/24/installation_guide/install

WORKDIR /tmp

ADD https://github.com/erlang/otp/releases/download/OTP-${ERLANG_VERSION}/otp_src_${ERLANG_VERSION}.tar.gz .
ADD https://github.com/erlang/rebar3/releases/latest/download/rebar3 .

RUN apk add --no-cache \
    build-base \
    ncurses-dev \
    openssl3-dev \
    perl \
    unixodbc-dev \
 && tar zxf otp_src_${ERLANG_VERSION}.tar.gz \
 && chown -R root:root ./*

WORKDIR /tmp/otp_src_${ERLANG_VERSION}

RUN ./configure \
    --without-javac \
    --without-wx

RUN make -j$(nproc)

RUN make install \
 && install -o root -g root -m 0755 /tmp/rebar3 /usr/local/bin/rebar3 \
 && find /usr/local -regex '/usr/local/lib/erlang/\(lib/\|erts-\).*/\(man\|doc\|obj\|c_src\|emacs\|info\|examples\)' | xargs rm -rf \
 && find /usr/local -name src | xargs -r find | grep -v '\.hrl$' | xargs rm -v || true \
 && find /usr/local -name src | xargs -r find | xargs rmdir -vp || true


FROM alpine:latest

RUN apk add --no-cache \
    inotify-tools \
    libcrypto3 \
    libgcc \
    libstdc++ \
    ncurses-libs \
    unixodbc

COPY rebar.config /root/.config/rebar3/
COPY --from=build /usr/local /usr/local

EXPOSE 8080

CMD ["/usr/local/bin/erl"]
