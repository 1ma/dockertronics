FROM alpine:3.24@sha256:3f4d6b32e26703c6082839234f43769d5046b3ac7c910033911d1e71d8cd630a AS verifier

ARG KNOTS_VERSION

WORKDIR /tmp

RUN KNOTS_MAJOR_VERSION=$(echo ${KNOTS_VERSION} | cut -c1-2) \
 && wget https://bitcoinknots.org/files/${KNOTS_MAJOR_VERSION}.x/${KNOTS_VERSION}/SHA256SUMS \
 && wget https://bitcoinknots.org/files/${KNOTS_MAJOR_VERSION}.x/${KNOTS_VERSION}/SHA256SUMS.asc \
 && wget https://bitcoinknots.org/files/${KNOTS_MAJOR_VERSION}.x/${KNOTS_VERSION}/bitcoin-${KNOTS_VERSION}.tar.gz

RUN apk add --no-cache \
    coreutils \
    curl \
    gnupg \
    jq \
 && curl -s https://api.github.com/repos/bitcoinknots/guix.sigs/contents/builder-keys | jq -r '.[].download_url' | while read url; do curl -s "$url" | gpg --import; done \
 && gpg --verify SHA256SUMS.asc SHA256SUMS \
 && sha256sum --ignore-missing -c SHA256SUMS \
 && tar zxf bitcoin-${KNOTS_VERSION}.tar.gz \
 && mv bitcoin-${KNOTS_VERSION} bitcoin


FROM alpine:3.24@sha256:3f4d6b32e26703c6082839234f43769d5046b3ac7c910033911d1e71d8cd630a AS signet-miner

ENV CLI_CMD_ARGS=
ENV MAX_INTERVAL=1800
ENV MINING_XPUB=tr(tpubXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/0/*)#xxxxxxxx

COPY --from=1maa/blakecoin:latest /usr/local/bin/bitcoin-cli  /usr/local/bin/bitcoin-cli
COPY --from=1maa/blakecoin:latest /usr/local/bin/bitcoin-util /usr/local/bin/bitcoin-util

COPY --from=verifier /tmp/bitcoin/test/functional/test_framework /usr/local/src/bitcoin/test/functional/test_framework
COPY --from=verifier /tmp/bitcoin/contrib/signet/miner           /usr/local/src/bitcoin/contrib/signet/miner

RUN sed -i '/if args\.max_interval < 960:/{     \
  N                                             \
  N                                             \
  d                                             \
}' /usr/local/src/bitcoin/contrib/signet/miner

COPY --chown=0:0 --chmod=755 signet-miner-entrypoint.sh /opt/entrypoint.sh

RUN apk add --no-cache \
    python3 \
 && adduser -D miner \
 && ln -s /usr/local/src/bitcoin/contrib/signet/miner /usr/local/bin/miner

USER miner

STOPSIGNAL SIGINT

ENTRYPOINT ["/opt/entrypoint.sh"]


FROM alpine:3.24@sha256:3f4d6b32e26703c6082839234f43769d5046b3ac7c910033911d1e71d8cd630a AS builder

WORKDIR /tmp

COPY --from=verifier /tmp/bitcoin bitcoin

RUN apk add --no-cache \
    bash \
    build-base \
    cmake \
    curl \
    linux-headers \
    pkgconf \
    upx

RUN make -C bitcoin/depends -j$(nproc) NO_QT=1 NO_NATPMP=1 NO_UPNP=1 NO_USDT=1

RUN cmake -S bitcoin -B build \
    -DAPPEND_CPPFLAGS=-g0 \
    -DAPPEND_LDFLAGS=-Wl,--strip-all \
    -DBUILD_SHARED_LIBS=OFF \
    -DBUILD_TESTS=OFF \
    -DBUILD_TX=ON \
    -DBUILD_UTIL=ON \
    -DBUILD_WALLET_TOOL=ON \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
    -DINSTALL_MAN=OFF \
    -DREDUCE_EXPORTS=ON \
    -DSECP256K1_APPEND_CFLAGS=-g0 \
    -DSECP256K1_APPEND_LDFLAGS=-Wl,--strip-all \
    -DWITH_BDB=ON \
    -DWITH_ZMQ=ON \
    --toolchain $(find /tmp/bitcoin/depends | grep -E "toolchain\.cmake$")

RUN cmake --build build -j $(nproc)

RUN cmake --install build

RUN upx --lzma /usr/local/bin/*


FROM alpine:3.24@sha256:3f4d6b32e26703c6082839234f43769d5046b3ac7c910033911d1e71d8cd630a AS final

COPY --from=builder /usr/local/bin/* /usr/local/bin/

RUN apk add --no-cache \
    libgcc \
    libstdc++ \
    tor \
 && adduser -D blakecoin \
 && mkdir /home/blakecoin/.bitcoin \
 && chown blakecoin:blakecoin /home/blakecoin/.bitcoin

USER blakecoin

VOLUME ["/home/blakecoin/.bitcoin"]

# REST interface
EXPOSE 8080

# P2P network (mainnet, testnet, regtest & signet respectively)
EXPOSE 8333 18333 18444 38333

# RPC interface (mainnet, testnet, regtest & signet respectively)
EXPOSE 8332 18332 18443 38332

# ZMQ ports (for block hashes, raw blocks & raw transactions respectively)
EXPOSE 8443 28332 28333

ENTRYPOINT ["/usr/local/bin/bitcoind", "-nodebuglogfile", "-zmqpubhashblock=tcp://0.0.0.0:8443", "-zmqpubrawblock=tcp://0.0.0.0:28332", "-zmqpubrawtx=tcp://0.0.0.0:28333"]
