FROM debian:trixie-slim AS builder

ARG ELECTRS_VERSION=v0.11.0

WORKDIR /tmp

COPY romanz.gpg .

RUN apt-get update \
 && apt-get install --yes --no-install-recommends \
    ca-certificates \
    clang \
    curl \
    git \
    gnupg \
    libclang-dev \
 && rm -rf /var/lib/apt/lists/* \
 && gpg --import romanz.gpg \
 && git clone --branch=${ELECTRS_VERSION} https://github.com/romanz/electrs \
 && curl -s https://sh.rustup.rs | sh -s -- -y --profile minimal

WORKDIR /tmp/electrs

RUN git verify-tag ${ELECTRS_VERSION}

RUN . "$HOME/.cargo/env" \
 && cargo build --locked --release


FROM debian:trixie-slim

COPY --from=builder /tmp/electrs/target/release/electrs /usr/local/bin/electrs

RUN groupadd -r electrs \
 && useradd -r -g electrs electrs \
 && mkdir /var/lib/electrs \
 && chown electrs:electrs /var/lib/electrs

USER electrs

VOLUME ["/var/lib/electrs"]

# Prometheus metrics for mainnet and signet
EXPOSE 4224 34224

# mainnet plain, mainnet ssl, signet plain, signet ssl
EXPOSE 50001 50002 60601 60602

ENTRYPOINT ["/usr/local/bin/electrs", "--db-dir", "/var/lib/electrs"]
