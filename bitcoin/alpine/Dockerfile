FROM alpine:latest AS builder

ARG BITCOIN_VERSION=25.1

WORKDIR /tmp

ADD https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS .
ADD https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS.asc .
ADD https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}.tar.gz .

COPY developer_pubkeys.pem .
COPY ordisrespector.patch .

RUN apk add --no-cache \
    coreutils \
    gnupg \
    gnupg-keyboxd \
 && gpg --import developer_pubkeys.pem \
 && gpg --verify SHA256SUMS.asc SHA256SUMS \
 && sha256sum --ignore-missing -c SHA256SUMS

RUN apk add --no-cache \
    autoconf \
    automake \
    build-base \
    curl \
    git \
    libtool \
    linux-headers \
    pkgconf \
    upx

RUN tar zxf bitcoin-${BITCOIN_VERSION}.tar.gz

RUN cd ./bitcoin-${BITCOIN_VERSION} \
 && git apply /tmp/ordisrespector.patch

RUN ./bitcoin-${BITCOIN_VERSION}/autogen.sh

RUN make -C bitcoin-${BITCOIN_VERSION}/depends -j$(nproc) NO_QT=1 NO_NATPMP=1 NO_UPNP=1 NO_USDT=1

ENV CFLAGS="-O2 --static -static -fPIC"
ENV CXXFLAGS="-O2 --static -static -fPIC"
ENV LDFLAGS="-s -static-libgcc -static-libstdc++"

RUN mkdir build \
 && cd build \
 && ../bitcoin-${BITCOIN_VERSION}/configure \
    CONFIG_SITE=/tmp/bitcoin-${BITCOIN_VERSION}/depends/x86_64-pc-linux-musl/share/config.site \
    --disable-bench \
    --disable-fuzz-binary \
    --disable-gui-tests \
    --disable-maintainer-mode \
    --disable-man \
    --disable-tests \
    --enable-lto \
    --with-daemon=yes \
    --with-gui=no \
    --with-libmultiprocess=no \
    --with-libs=no \
    --with-miniupnpc=no \
    --with-mpgen=no \
    --with-natpmp=no \
    --with-qrencode=no \
    --with-utils=yes

RUN make -C ./build -j$(nproc)

RUN make -C ./build install \
 && file /usr/local/bin/* \
 && upx --lzma /usr/local/bin/*


FROM alpine:latest

COPY --from=builder /usr/local/bin/* /usr/local/bin/

COPY bitcoin.conf /etc/bitcoin/bitcoin.conf

RUN mkdir /root/.bitcoin && echo "datadir=/var/lib/bitcoin" > /root/.bitcoin/bitcoin.conf

VOLUME /var/lib/bitcoin

EXPOSE 8333

CMD ["/usr/local/bin/bitcoind", "-conf=/etc/bitcoin/bitcoin.conf"]
