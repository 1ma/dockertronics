FROM golang:trixie AS trustedcoin

ARG TRUSTEDCOIN_VERSION=v0.8.6

ENV CGO_ENABLED=0

RUN go install -trimpath -ldflags="-d -s -w" github.com/nbd-wtf/trustedcoin@${TRUSTEDCOIN_VERSION}


FROM debian:trixie-slim AS builder

ARG CLN_VERSION=v25.12.1

ENV PATH="/root/.cargo/bin:${PATH}"

RUN apt-get update \
 && DEBIAN_FRONTEND="noninteractive" apt-get install --yes --no-install-recommends \
    autoconf \
    automake \
    build-essential \
    curl \
    gettext \
    git \
    gnupg \
    jq \
    libpq-dev \
    libsodium-dev \
    libsqlite3-dev \
    libtool \
    lowdown \
    protobuf-compiler \
    python3-pip \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

RUN pip install --break-system-packages --user \
    grpcio-tools \
    mako \
 && curl -s https://sh.rustup.rs | sh -s -- -y --profile minimal

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


FROM debian:trixie-slim AS final

COPY --from=builder /usr/local/bin     /usr/local/bin
COPY --from=builder /usr/local/libexec /usr/local/libexec

RUN apt-get update \
 && DEBIAN_FRONTEND="noninteractive" apt-get install --yes --no-install-recommends \
    adduser \
    ca-certificates \
    libpq5 \
    libsodium23 \
    python-is-python3 \
 && rm -rf /var/lib/apt/lists/* \
 && addgroup --system cln \
 && adduser --system --disabled-password --home /home/cln --shell /bin/false --gecos cln --ingroup cln cln \
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
