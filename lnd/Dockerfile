FROM golang:1.25-alpine AS build

ARG LND_VERSION=0.20.0-beta
ARG RELEASE_SIGNER=ellemouton

ENV CGO_ENABLED=0

WORKDIR /tmp

ADD https://github.com/lightningnetwork/lnd/releases/download/v${LND_VERSION}/lnd-source-v${LND_VERSION}.tar.gz .
ADD https://github.com/lightningnetwork/lnd/releases/download/v${LND_VERSION}/manifest-${RELEASE_SIGNER}-v${LND_VERSION}.sig .
ADD https://github.com/lightningnetwork/lnd/releases/download/v${LND_VERSION}/manifest-v${LND_VERSION}.txt .

COPY developer_pubkeys.pem .

RUN apk add --no-cache \
    coreutils \
    gnupg \
 && gpg --import developer_pubkeys.pem \
 && gpg --verify manifest-${RELEASE_SIGNER}-v${LND_VERSION}.sig manifest-v${LND_VERSION}.txt \
 && sha256sum --ignore-missing -c manifest-v${LND_VERSION}.txt

RUN apk add --no-cache \
    file \
    git \
    make \
    upx \
 && tar zxf lnd-source-v${LND_VERSION}.tar.gz \
 && cd lnd-source \
 && go install -trimpath -ldflags "-d -s -w -X github.com/lightningnetwork/lnd/build.Commit=v${LND_VERSION} -X github.com/lightningnetwork/lnd/build.GoVersion=${GOLANG_VERSION}" github.com/lightningnetwork/lnd/cmd/lnd \
 && go install -trimpath -ldflags "-d -s -w -X github.com/lightningnetwork/lnd/build.Commit=v${LND_VERSION} -X github.com/lightningnetwork/lnd/build.GoVersion=${GOLANG_VERSION}" github.com/lightningnetwork/lnd/cmd/lncli \
 && file /go/bin/* \
 && upx --lzma /go/bin/*


FROM alpine:latest

COPY --from=build /go/bin /usr/local/bin

CMD ["/usr/local/bin/lnd"]
