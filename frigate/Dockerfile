ARG PUBLIC_DEBIAN_IMAGE="sha256:0000000000000000000000000000000000000000000000000000000000000000"
ARG PUBLIC_ECLIPSE_TEMURIN_IMAGE="sha256:0000000000000000000000000000000000000000000000000000000000000000"

FROM eclipse-temurin@${PUBLIC_ECLIPSE_TEMURIN_IMAGE} AS builder

ARG FRIGATE_VERSION=1.5.2

WORKDIR /tmp

RUN apt-get update \
 && apt-get install --yes --no-install-recommends \
    binutils \
    fakeroot \
    git \
    rpm

RUN git clone --recursive --branch ${FRIGATE_VERSION} https://github.com/sparrowwallet/frigate.git

WORKDIR /tmp/frigate

RUN ./gradlew jpackage

RUN dpkg -i ./build/jpackage/frigate_${FRIGATE_VERSION}_*.deb


FROM debian@${PUBLIC_DEBIAN_IMAGE} AS final

ENV CORE_SERVER=http://127.0.0.1:8332
ENV CORE_AUTH_TYPE=COOKIE
ENV CORE_DATA_DIR=/home/bitcoin/.bitcoin
ENV CORE_AUTH=user:password
ENV CORE_ZMQ_SEQUENCE_ENDPOINT=tcp://127.0.0.1:28336

ENV INDEX_START_HEIGHT=709632

ENV SERVER_TCP=tcp://0.0.0.0:50001
ENV SERVER_BACKEND_ELECTRUM_SERVER=tcp://127.0.0.1:60001

COPY --chmod=755    entrypoint.sh /usr/local/bin/entrypoint.sh
COPY --from=builder /opt/frigate  /opt/frigate

RUN apt-get update \
 && apt-get install --yes --no-install-recommends \
    gettext-base \
 && rm -rf /var/lib/apt/lists/* \
 && groupadd -r frigate \
 && useradd -m -r -g frigate frigate

USER frigate

RUN mkdir /home/frigate/.frigate

VOLUME ["/home/frigate/.frigate"]

COPY --chmod=644 config.template.toml /tmp/config.template.toml

# mainnet plain, signet plain
EXPOSE 50001 60601

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/opt/frigate/bin/frigate"]
