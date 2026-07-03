ARG PUBLIC_ALPINE_IMAGE="sha256:0000000000000000000000000000000000000000000000000000000000000000"
ARG PUBLIC_GOLANG_IMAGE="sha256:0000000000000000000000000000000000000000000000000000000000000000"

FROM golang@${PUBLIC_GOLANG_IMAGE} AS trustedcoin

ARG TRUSTEDCOIN_VERSION=v0.8.6

ENV CGO_ENABLED=0

RUN go install -trimpath -ldflags="-d -s -w" github.com/nbd-wtf/trustedcoin@${TRUSTEDCOIN_VERSION}


FROM alpine@${PUBLIC_ALPINE_IMAGE} AS builder

ARG CLN_VERSION=v26.06.2

ENV PATH="/root/.cargo/bin:/root/.local/bin/:${PATH}"

RUN apk add --no-cache \
    autoconf \
    automake \
    build-base \
    curl \
    gettext \
    git \
    gnupg \
    jq \
    libffi-dev \
    libpq-dev \
    libsodium-dev \
    libtool \
    lowdown \
    openssl \
    protoc \
    py3-pip \
    python3-dev \
    sqlite-dev \
    sqlite-static \
    zlib-dev \
    zlib-static

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


FROM alpine@${PUBLIC_ALPINE_IMAGE} AS final

COPY --from=builder /usr/local/bin     /usr/local/bin
COPY --from=builder /usr/local/libexec /usr/local/libexec

RUN apk add --no-cache \
    ca-certificates \
    libgcc \
    libpq \
    libsodium \
    sqlite-libs \
 && addgroup --system cln \
 && adduser --system --disabled-password --shell /bin/false --gecos cln --ingroup cln cln \
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
