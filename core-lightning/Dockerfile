FROM ubuntu:22.04 AS builder

ARG CLN_VERSION=v24.02.1

WORKDIR /tmp

RUN apt-get update \
 && apt-get install --yes --no-install-recommends \
    autoconf \
    automake \
    build-essential \
    gettext \
    git \
    gnupg \
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

RUN pip3 install --user \
    grpcio-tools \
    mako

RUN git clone --depth 1 --branch ${CLN_VERSION} https://github.com/ElementsProject/lightning.git

WORKDIR /tmp/lightning

COPY developer_pubkeys.pem .

RUN gpg --import developer_pubkeys.pem \
 && git verify-tag "${CLN_VERSION}"

ENV LDFLAGS="-s"

RUN ./configure \
    --disable-rust \
    --enable-static

RUN make -j$(nproc)

RUN make install


FROM ubuntu:22.04

COPY --from=builder /usr/local/bin     /usr/local/bin
COPY --from=builder /usr/local/libexec /usr/local/libexec

CMD ["/usr/local/bin/lightningd"]
