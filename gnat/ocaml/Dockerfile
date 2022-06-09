FROM 1maa/gcc:latest

ARG DEBIAN_FRONTEND=noninteractive
ARG OPAM_VERSION=2.0.8
ARG OCAML_VERSION=4.07.1

WORKDIR /tmp

ADD https://github.com/ocaml/opam/releases/download/${OPAM_VERSION}/opam-${OPAM_VERSION}-x86_64-linux /usr/local/bin/opam

RUN apt-get update \
 && apt-get install --yes \
    autoconf \
    git \
    libgmp-dev \
    m4 \
    pkg-config \
    unzip \
    wget \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/* \
 && chmod +x /usr/local/bin/opam

RUN opam init --compiler=4.07.1 --disable-sandboxing --shell-setup \
 && chown -R root:root ~/.opam

RUN opam install --yes \
    camlzip \
    menhir \
    ocamlgraph \
    ocplib-simplex \
    yojson \
    zarith \
 && chown -R root:root /root/.opam


FROM ubuntu:20.04

COPY --from=0 /root/.opam /root/.opam

# OPAM configuration
RUN echo "test -r /root/.opam/opam-init/init.sh && . /root/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true" >> /root/.profile
