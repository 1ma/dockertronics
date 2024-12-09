FROM golang:1.23-bookworm AS trustedcoin

ARG TRUSTEDCOIN_VERSION=v0.8.3

ENV CGO_ENABLED=0

RUN go install -trimpath -ldflags="-d -s -w" github.com/nbd-wtf/trustedcoin@${TRUSTEDCOIN_VERSION}


FROM debian:12-slim AS builder

ARG CLN_VERSION=v24.11


RUN apt-get update \
 && DEBIAN_FRONTEND="noninteractive" apt-get install --yes --no-install-recommends \
    autoconf \
    automake \
    build-essential \
    ca-certificates \
    gettext \
    git \
    gnupg \
    jq \
    libgmp-dev \
    libpq-dev \
    libsodium-dev \
    libsqlite3-dev \
    libtool \
    net-tools \
    python3-pip \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

RUN pip3 install --break-system-packages --user \
    grpcio-tools \
    mako

WORKDIR /tmp

COPY developer_pubkeys.pem .

RUN git clone --depth 1 --branch ${CLN_VERSION} --recurse-submodules https://github.com/ElementsProject/lightning.git

WORKDIR /tmp/lightning

RUN gpg --import /tmp/developer_pubkeys.pem \
 && git verify-tag "${CLN_VERSION}"

ENV LDFLAGS="-s"

RUN ./configure \
    --disable-rust \
    --enable-static

RUN make -j$(nproc) \
 && git checkout -- .

RUN make install

COPY --from=trustedcoin /go/bin/trustedcoin /usr/local/libexec/c-lightning/plugins/


FROM debian:12-slim AS final

COPY --from=builder /usr/local/bin     /usr/local/bin
COPY --from=builder /usr/local/libexec /usr/local/libexec

RUN apt-get update \
 && DEBIAN_FRONTEND="noninteractive" apt-get install --yes --no-install-recommends \
    ca-certificates \
    libpq5 \
    python-is-python3 \
 && rm -rf /var/lib/apt/lists/* \
 && addgroup --system cln \
 && adduser --system --disabled-password --home /home/cln --shell /bin/false --gecos cln --ingroup cln cln \
 && mkdir -p /home/cln/.lightning/bitcoin \
 && chmod -R 700 /home/cln/.lightning \
 && echo "disable-plugin=bcli" >> /home/cln/.lightning/config \
 && echo "disable-plugin=wss-proxy" >> /home/cln/.lightning/config \
 && echo "disable-plugin=clnrest" >> /home/cln/.lightning/config \
 && chown -R cln:cln /home/cln/.lightning

VOLUME /home/.cln/.lightning/bitcoin

USER cln

EXPOSE 9735

CMD ["/usr/local/bin/lightningd", "--plugin", "/usr/local/libexec/c-lightning/plugins/trustedcoin"]
