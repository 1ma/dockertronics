FROM golang:alpine AS plugins

RUN go install -ldflags="-d -s -w" -trimpath google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest \
 && go install -ldflags="-d -s -w" -trimpath google.golang.org/protobuf/cmd/protoc-gen-go@latest


FROM alpine:latest

COPY --from=plugins /go/bin /usr/local/bin

RUN apk add --no-cache \
    protobuf-dev \
    protoc
