FROM golang:1.24-alpine AS trustedcoin

ARG TRUSTEDCOIN_VERSION=v0.8.3

ENV CGO_ENABLED=0

RUN go install -trimpath -ldflags="-d -s -w" github.com/nbd-wtf/trustedcoin@${TRUSTEDCOIN_VERSION}


FROM alpine:3.21 AS builder

ARG CLN_VERSION=v25.02.2

ENV PATH="/root/.cargo/bin:${PATH}"

RUN apk add --no-cache \
    autoconf \
    automake \
    build-base \
    curl \
    gettext \
    git \
    gnupg \
    jq \
    libpq-dev \
    libsodium-dev \
    libtool \
    protoc \
    py3-pip \
    py3-setuptools \
    sqlite-dev \
    sqlite-static \
    zlib-dev \
    zlib-static

RUN pip install --break-system-packages --user \
    grpcio-tools \
    mako \
 && curl -s https://sh.rustup.rs | sh -s -- -y

WORKDIR /tmp

COPY developer_pubkeys.pem .

RUN git clone --depth 1 --branch ${CLN_VERSION} --recurse-submodules https://github.com/ElementsProject/lightning.git

WORKDIR /tmp/lightning

RUN gpg --import /tmp/developer_pubkeys.pem \
 && git verify-tag "${CLN_VERSION}"

ENV LDFLAGS="-s"

RUN ./configure \
    --enable-static

RUN make RUST_PROFILE=release \
 && git checkout -- .

RUN make install RUST_PROFILE=release

COPY --from=trustedcoin /go/bin/trustedcoin /usr/local/libexec/c-lightning/plugins/


FROM alpine:3.21 AS final

COPY --from=builder /usr/local/bin     /usr/local/bin
COPY --from=builder /usr/local/libexec /usr/local/libexec

RUN apk add --no-cache \
    ca-certificates \
    libgcc \
    libpq \
    libsodium \
 && addgroup --system cln \
 && adduser --system --disabled-password --shell /bin/false --gecos cln --ingroup cln cln \
 && mkdir -p /home/cln/.lightning/bitcoin \
 && chmod -R 700 /home/cln/.lightning \
 && echo "disable-plugin=bcli" >> /home/cln/.lightning/config \
 && echo "disable-plugin=cln-grpc" >> /home/cln/.lightning/config \
 && echo "disable-plugin=clnrest" >> /home/cln/.lightning/config \
 && echo "disable-plugin=wss-proxy" >> /home/cln/.lightning/config \
 && echo "xpay-handle-pay=true" >> /home/cln/.lightning/config \
 && chown -R cln:cln /home/cln/.lightning

VOLUME /home/.cln/.lightning/bitcoin

USER cln

EXPOSE 9735

CMD ["/usr/local/bin/lightningd", "--plugin", "/usr/local/libexec/c-lightning/plugins/trustedcoin"]
