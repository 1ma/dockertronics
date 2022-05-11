FROM ubuntu:latest AS builder

ENV BITCOIN_VERSION=22.0

WORKDIR /tmp

ADD https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS .
ADD https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS.asc .
ADD https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}.tar.gz .

COPY developer_pubkeys.pem .

RUN apt-get update \
 && apt-get install --yes --no-install-recommends \
    gnupg \
 && gpg --import developer_pubkeys.pem \
 && gpg --verify SHA256SUMS.asc SHA256SUMS \
 && sha256sum --ignore-missing -c SHA256SUMS

 RUN apt-get install --yes --no-install-recommends \
     autoconf \
     automake \
     build-essential \
     libboost-all-dev \
     libevent-dev \
     libsqlite3-dev \
     libtool \
     pkg-config \
     upx

RUN tar zxf bitcoin-${BITCOIN_VERSION}.tar.gz

RUN ./bitcoin-${BITCOIN_VERSION}/autogen.sh

ENV CFLAGS="-O2 --static -static -fPIC"
ENV CXXFLAGS="-O2 --static -static -fPIC"
ENV LDFLAGS="-s -static-libgcc -static-libstdc++"

RUN mkdir build \
 && cd build \
 && ../bitcoin-${BITCOIN_VERSION}/configure \
    --disable-bench \
    --disable-gui-tests \
    --disable-maintainer-mode \
    --disable-man \
    --disable-tests \
    --disable-zmq \
    --with-gui=no \
    --with-libs=no \
    --without-bdb

RUN make -C ./build -j$(nproc)

RUN make -C ./build install \
 && file /usr/local/bin/* \
 && upx --lzma /usr/local/bin/*


FROM ubuntu:latest

COPY --from=builder /usr/local/bin/* /usr/local/bin/

VOLUME /var/lib/bitcoin

EXPOSE 8333

CMD ["/usr/local/bin/bitcoind", "-datadir=/var/lib/bitcoin", "-nodebuglogfile"]