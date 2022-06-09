FROM alpine:latest

ARG ALIRE_VERSION=1.1.1

WORKDIR /tmp

ADD https://github.com/alire-project/alire/releases/download/v${ALIRE_VERSION}/alr-${ALIRE_VERSION}-bin-x86_64-linux.zip .

RUN unzip alr-${ALIRE_VERSION}-bin-x86_64-linux.zip \
 && apk add binutils \
 && strip --strip-all bin/alr


FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

COPY --from=0 /tmp/bin/alr /usr/local/bin/alr

RUN apt-get update && apt-get install -y \
    curl \
    git \
    gnat \
    gprbuild \
    unzip \
 && rm -rf /var/lib/apt/lists/*
