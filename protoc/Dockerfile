ARG PUBLIC_ALPINE_IMAGE="sha256:0000000000000000000000000000000000000000000000000000000000000000"
ARG PUBLIC_GOLANG_IMAGE="sha256:0000000000000000000000000000000000000000000000000000000000000000"

FROM golang@${PUBLIC_GOLANG_IMAGE} AS plugins

RUN go install -ldflags="-d -s -w" -trimpath google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest \
 && go install -ldflags="-d -s -w" -trimpath google.golang.org/protobuf/cmd/protoc-gen-go@latest


FROM alpine@${PUBLIC_ALPINE_IMAGE} AS types

ARG PROTOC_VERSION=31.1

WORKDIR /tmp

ADD https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip .

RUN unzip protoc-${PROTOC_VERSION}-linux-x86_64.zip \
 && find ./include -type d -exec chmod 755 {} \; \
 && find ./include -type f -exec chmod 644 {} \;


FROM alpine@${PUBLIC_ALPINE_IMAGE}

COPY --from=plugins /go/bin      /usr/local/bin
COPY --from=types   /tmp/include /usr/include

RUN apk add --no-cache protoc
