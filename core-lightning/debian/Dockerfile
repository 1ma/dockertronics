ARG PUBLIC_DEBIAN_IMAGE="sha256:0000000000000000000000000000000000000000000000000000000000000000"
ARG PUBLIC_GOLANG_IMAGE="sha256:0000000000000000000000000000000000000000000000000000000000000000"

FROM golang@${PUBLIC_GOLANG_IMAGE} AS trustedcoin

ARG TRUSTEDCOIN_VERSION=v0.8.6

ENV CGO_ENABLED=0

RUN go install -trimpath -ldflags="-d -s -w" github.com/nbd-wtf/trustedcoin@${TRUSTEDCOIN_VERSION}


FROM debian@${PUBLIC_DEBIAN_IMAGE} AS builder

ARG CLN_VERSION=v26.06.1

ENV PATH="/root/.cargo/bin:/root/.local/bin/:${PATH}"

RUN apt-get update \
 && DEBIAN_FRONTEND="noninteractive" apt-get install --yes --no-install-recommends \
    autoconf \
    automake \
    build-essential \
    curl \
    gettext \
    git \
    gnupg \
    jq \
    libffi-dev \
    libpq-dev \
    libsodium-dev \
    libsqlite3-dev \
    libtool \
    lowdown \
    pkgconf \
    protobuf-compiler \
    python3-dev \
    python3-pip \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

RUN curl -s https://sh.rustup.rs | sh -s -- -y --profile minimal \
 && curl -LsSf https://astral.sh/uv/install.sh | sh

WORKDIR /tmp

COPY developer_pubkeys.pem .

RUN git clone --depth 1 --branch ${CLN_VERSION} --recurse-submodules https://github.com/ElementsProject/lightning.git

WORKDIR /tmp/lightning

RUN gpg --import /tmp/developer_pubkeys.pem \
 && git verify-tag "${CLN_VERSION}"

ENV CARGO_PROFILE_RELEASE_STRIP=symbols
ENV LDFLAGS="-s"

RUN uv sync --all-extras --all-groups --frozen
RUN ./configure
RUN RUST_PROFILE=release uv run make
RUN RUST_PROFILE=release make install

COPY --from=trustedcoin /go/bin/trustedcoin /usr/local/libexec/c-lightning/plugins/


FROM debian@${PUBLIC_DEBIAN_IMAGE} AS final

COPY --from=builder /usr/local/bin     /usr/local/bin
COPY --from=builder /usr/local/libexec /usr/local/libexec

RUN apt-get update \
 && DEBIAN_FRONTEND="noninteractive" apt-get install --yes --no-install-recommends \
    adduser \
    ca-certificates \
    libpq5 \
    libsodium23 \
    libsqlite3-0 \
 && rm -rf /var/lib/apt/lists/* \
 && addgroup --system cln \
 && adduser --system --disabled-password --home /home/cln --shell /bin/false --gecos cln --ingroup cln cln \
 && mkdir -p /home/cln/.lightning/bitcoin \
 && chmod -R 700 /home/cln/.lightning \
 && echo "disable-plugin=bcli" >> /home/cln/.lightning/config \
 && echo "disable-plugin=cln-grpc" >> /home/cln/.lightning/config \
 && echo "disable-plugin=clnrest" >> /home/cln/.lightning/config \
 && echo "disable-plugin=wss-proxy" >> /home/cln/.lightning/config \
 && chown -R cln:cln /home/cln/.lightning

VOLUME /home/.cln/.lightning/bitcoin

USER cln

EXPOSE 9735

CMD ["/usr/local/bin/lightningd", "--plugin", "/usr/local/libexec/c-lightning/plugins/trustedcoin"]
