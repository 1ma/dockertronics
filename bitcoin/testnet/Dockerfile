ARG BITCOIN_TAG=v25

FROM 1maa/bitcoin:${BITCOIN_TAG}

RUN echo >> /etc/bitcoin/bitcoin.conf \
 && echo "testnet=1" >> /etc/bitcoin/bitcoin.conf \
 && echo "testnet=1" >> /root/.bitcoin/bitcoin.conf

EXPOSE 18333
