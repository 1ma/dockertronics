FROM golang:alpine

WORKDIR /root

COPY ./main.go .

RUN apk add --no-cache \
    file \
    upx \
 && GO111MODULE=auto CGO_ENABLE=0 go build -trimpath -tags netgo -v -ldflags="-d -s -w" -o sleepy \
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
