FROM golang:alpine@sha256:d200d2dd76b03a99b52651fd1325aff7dcd35422c35c01bac56571b0507f3deb AS plugins

RUN go install -ldflags="-d -s -w" -trimpath google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest \
 && go install -ldflags="-d -s -w" -trimpath google.golang.org/protobuf/cmd/protoc-gen-go@latest


FROM alpine:3.24@sha256:3f4d6b32e26703c6082839234f43769d5046b3ac7c910033911d1e71d8cd630a AS types

ARG PROTOC_VERSION=31.1

WORKDIR /tmp

ADD https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip .

RUN unzip protoc-${PROTOC_VERSION}-linux-x86_64.zip \
 && find ./include -type d -exec chmod 755 {} \; \
 && find ./include -type f -exec chmod 644 {} \;


FROM alpine:3.24@sha256:3f4d6b32e26703c6082839234f43769d5046b3ac7c910033911d1e71d8cd630a

COPY --from=plugins /go/bin      /usr/local/bin
COPY --from=types   /tmp/include /usr/include

RUN apk add --no-cache protoc
