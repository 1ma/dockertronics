FROM debian:trixie-slim@sha256:a72b4433de1cf7d6bae0c4cee74d0547f58601a643b3375f070c51600d63b6b2 AS builder

ARG ELECTRS_VERSION=v0.11.1

WORKDIR /tmp

COPY allowed_signers .

RUN apt-get update \
 && apt-get install --yes --no-install-recommends \
    ca-certificates \
    clang \
    curl \
    git \
    libclang-dev \
    openssh-client \
 && rm -rf /var/lib/apt/lists/* \
 && git clone --branch=${ELECTRS_VERSION} https://github.com/romanz/electrs \
 && curl -s https://sh.rustup.rs | sh -s -- -y --profile minimal

WORKDIR /tmp/electrs

RUN git config gpg.ssh.allowedSignersFile /tmp/allowed_signers \
 && git verify-tag ${ELECTRS_VERSION}

ENV CARGO_PROFILE_RELEASE_STRIP=symbols

RUN . "$HOME/.cargo/env" \
 && cargo build --locked --release


FROM debian:trixie-slim@sha256:a72b4433de1cf7d6bae0c4cee74d0547f58601a643b3375f070c51600d63b6b2

COPY --from=builder /tmp/electrs/target/release/electrs /usr/local/bin/electrs

RUN groupadd -r electrs \
 && useradd -r -g electrs electrs \
 && mkdir /var/lib/electrs \
 && chown electrs:electrs /var/lib/electrs

USER electrs

VOLUME ["/var/lib/electrs"]

# Prometheus metrics for mainnet and signet
EXPOSE 4224 34224

# mainnet plaintext, mainnet ssl, signet plaintext, signet ssl
EXPOSE 50001 50002 60601 60602

ENTRYPOINT ["/usr/local/bin/electrs", "--db-dir", "/var/lib/electrs"]
