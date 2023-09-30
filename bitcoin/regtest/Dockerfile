FROM 1maa/bitcoin:v25

RUN echo >> /etc/bitcoin/bitcoin.conf \
 && echo "regtest=1" >> /etc/bitcoin/bitcoin.conf \
 && echo "dnsseed=0" >> /etc/bitcoin/bitcoin.conf \
 && echo "regtest=1" >> /root/.bitcoin/bitcoin.conf

EXPOSE 18444
