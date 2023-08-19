FROM alpine:latest AS builder

ARG BITCOIN_VERSION=25.0

WORKDIR /tmp

ADD https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS .
ADD https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS.asc .
ADD https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}.tar.gz .

COPY developer_pubkeys.pem .

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
    boost-dev \
    boost-static \
    build-base \
    curl \
    libevent-dev \
    libevent-static \
    libtool \
    pkgconf \
    sqlite-dev \
    sqlite-static \
    upx

RUN tar zxf bitcoin-${BITCOIN_VERSION}.tar.gz

RUN ./bitcoin-${BITCOIN_VERSION}/autogen.sh

# builds BerkeleyDB 4.8 in the depends subdirectory
RUN make -C bitcoin-${BITCOIN_VERSION}/depends NO_BOOST=1 NO_LIBEVENT=1 NO_QT=1 NO_SQLITE=1 NO_NATPMP=1 NO_UPNP=1 NO_ZMQ=1 NO_USDT=1

ENV BDB_PREFIX="/tmp/bitcoin-${BITCOIN_VERSION}/depends/x86_64-pc-linux-musl"
ENV CFLAGS="-O2 --static -static -fPIC"
ENV CXXFLAGS="-O2 --static -static -fPIC"
ENV LDFLAGS="-s -static-libgcc -static-libstdc++"

RUN mkdir build \
 && cd build \
 && ../bitcoin-${BITCOIN_VERSION}/configure \
    BDB_CFLAGS="-I${BDB_PREFIX}/include" \
    BDB_LIBS="-L${BDB_PREFIX}/lib -ldb_cxx-4.8" \
    --disable-bench \
    --disable-gui-tests \
    --disable-maintainer-mode \
    --disable-man \
    --disable-tests \
    --disable-zmq \
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

VOLUME /var/lib/bitcoin

EXPOSE 8333

CMD ["/usr/local/bin/bitcoind", "-datadir=/var/lib/bitcoin", "-listen=1", "-bind=0.0.0.0", "-nodebuglogfile"]
