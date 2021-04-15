FROM alpine:3.13

ENV ALIRE_VERSION 1.0.0

WORKDIR /tmp

ADD https://github.com/alire-project/alire/releases/download/v${ALIRE_VERSION}/alr-${ALIRE_VERSION}-bin-linux.zip .

RUN unzip alr-${ALIRE_VERSION}-bin-linux.zip \
 && apk add binutils \
 && strip --strip-all bin/alr


FROM ubuntu:21.04

ENV DEBIAN_FRONTEND noninteractive

COPY --from=0 /tmp/bin/alr /usr/local/bin/alr

RUN apt-get update && apt-get install -y \
    curl \
    git \
    gnat \
    gprbuild \
    unzip \
 && rm -rf /var/lib/apt/lists/*
