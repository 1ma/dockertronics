FROM golang:alpine

RUN apk add --no-cache \
    protobuf-dev \
    protoc \
 && GOCACHE=/tmp/go-build go install -ldflags="-d -s -w" -trimpath google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest \
 && GOCACHE=/tmp/go-build go install -ldflags="-d -s -w" -trimpath google.golang.org/protobuf/cmd/protoc-gen-go@latest \
 && rm -rf /go/pkg /tmp/go-build
