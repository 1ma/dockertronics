FROM alpine:3.19 AS verifier

ARG BITCOIN_VERSION=26.1

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


FROM alpine:3.19 AS builder

ARG BITCOIN_VERSION=26.1

WORKDIR /tmp

COPY --from=verifier /tmp/bitcoin-${BITCOIN_VERSION}.tar.gz .

RUN tar zxf bitcoin-${BITCOIN_VERSION}.tar.gz \
 && mv bitcoin-${BITCOIN_VERSION} bitcoin


FROM alpine:3.19 AS final

COPY --from=1maa/bitcoin:v26 /usr/local/bin/bitcoin-cli  /usr/local/bin/bitcoin-cli
COPY --from=1maa/bitcoin:v26 /usr/local/bin/bitcoin-util /usr/local/bin/bitcoin-util

COPY --from=builder /tmp/bitcoin/test/functional/test_framework /opt/bitcoin/test/functional/test_framework
COPY --from=builder /tmp/bitcoin/contrib/signet/miner           /opt/bitcoin/contrib/signet/miner

RUN apk add --no-cache \
    python3 \
 && ln -s /opt/bitcoin/contrib/signet/miner /usr/local/bin/miner

ENTRYPOINT ["/opt/bitcoin/contrib/signet/miner"]
