FROM golang:alpine AS plugins

RUN go install -ldflags="-d -s -w" -trimpath google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest \
 && go install -ldflags="-d -s -w" -trimpath google.golang.org/protobuf/cmd/protoc-gen-go@latest


FROM alpine:latest AS types

ARG PROTOC_VERSION=21.12

WORKDIR /tmp

ADD https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip .

RUN unzip protoc-${PROTOC_VERSION}-linux-x86_64.zip \
 && find ./include -type d -exec chmod 755 {} \; \
 && find ./include -type f -exec chmod 644 {} \;


FROM alpine:latest

COPY --from=plugins /go/bin      /usr/local/bin
COPY --from=types   /tmp/include /usr/include

RUN apk add --no-cache protoc
