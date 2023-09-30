ARG BITCOIN_TAG=v25

FROM 1maa/bitcoin:${BITCOIN_TAG}

RUN echo >> /etc/bitcoin/bitcoin.conf \
 && echo "regtest=1" >> /etc/bitcoin/bitcoin.conf \
 && echo "dnsseed=0" >> /etc/bitcoin/bitcoin.conf \
 && echo "fallbackfee=0.00001" >> /etc/bitcoin/bitcoin.conf \
 && echo "regtest=1" >> /root/.bitcoin/bitcoin.conf

EXPOSE 18444
