FROM debian:12-slim AS builder

ARG CLN_VERSION=v24.05

WORKDIR /tmp

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
    libsodium-dev \
    libsqlite3-dev \
    libtool \
    net-tools \
    python3 \
    python3-dev \
    python3-pip \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

RUN pip3 install --break-system-packages --user \
    grpcio-tools \
    mako

RUN git clone --depth 1 --branch ${CLN_VERSION} --recurse-submodules https://github.com/ElementsProject/lightning.git

COPY developer_pubkeys.pem .

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


FROM golang:1.22-bookworm AS trustedcoin

ENV CGO_ENABLED=0

RUN go install -trimpath -ldflags="-d -s -w" github.com/nbd-wtf/trustedcoin@latest \
 && chown 100:101 /go/bin/trustedcoin


FROM debian:12-slim AS final

COPY --from=builder /usr/local/bin     /usr/local/bin
COPY --from=builder /usr/local/libexec /usr/local/libexec

RUN apt-get update \
 && DEBIAN_FRONTEND="noninteractive" apt-get install --yes --no-install-recommends \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/* \
 && addgroup --system cln \
 && adduser --system --disabled-password --home /home/cln --shell /bin/false --gecos cln --ingroup cln cln \
 && mkdir -p /home/cln/.lightning/bitcoin /home/cln/.lightning/plugins \
 && chmod -R 700 /home/cln/.lightning \
 && echo "disable-plugin=bcli" > /home/cln/.lightning/config \
 && chown -R cln:cln /home/cln/.lightning

VOLUME /home/.cln/.lightning/bitcoin

USER cln

COPY --from=trustedcoin /go/bin/trustedcoin /home/cln/.lightning/plugins/


CMD ["/usr/local/bin/lightningd"]
