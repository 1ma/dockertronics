FROM ubuntu:latest AS builder

ARG CLN_VERSION=v0.11.1

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
    zlib1g-dev

RUN pip3 install \
    mako \
    mistune==0.8.4 \
    mrkd \
    poetry

RUN git clone --depth 1 --branch ${CLN_VERSION} https://github.com/ElementsProject/lightning.git

WORKDIR /tmp/lightning

COPY developer_pubkey.pem .

RUN gpg --import developer_pubkey.pem \
 && git verify-tag ${CLN_VERSION}

RUN poetry install

ENV LDFLAGS="-s"

RUN ./configure \
    --enable-experimental-features \
    --enable-static

RUN make -j$(nproc)

RUN make install


FROM ubuntu:latest

COPY --from=builder /usr/local/bin/lightning* /usr/local/bin/
COPY --from=builder /usr/local/libexec        /usr/local/libexec

CMD ["/usr/local/bin/lightningd"]
