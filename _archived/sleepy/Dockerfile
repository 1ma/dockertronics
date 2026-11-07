FROM golang:alpine@sha256:d200d2dd76b03a99b52651fd1325aff7dcd35422c35c01bac56571b0507f3deb

WORKDIR /root

COPY ./main.go .

RUN apk add --no-cache \
    file \
    upx \
 && GO111MODULE=off CGO_ENABLED=0 go build -trimpath -ldflags="-d -s -w" -o sleepy \
 && file sleepy \
 && upx --lzma sleepy \
 && file sleepy \
 && echo "nobody:x:65534:65534:nobody:/:/sbin/nologin" > passwd

FROM scratch

COPY --from=0 /root/passwd /etc/passwd
COPY --from=0 /root/sleepy /sleepy

USER nobody

EXPOSE 1234

ENTRYPOINT ["/sleepy"]
