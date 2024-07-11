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


FROM debian:12-slim

COPY --from=builder /usr/local/bin     /usr/local/bin
COPY --from=builder /usr/local/libexec /usr/local/libexec

CMD ["/usr/local/bin/lightningd"]
