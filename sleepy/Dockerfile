FROM golang:alpine

COPY ./main.go /root/main.go

RUN cd ~ \
 && CGO_ENABLE=0 go build -tags netgo -v -ldflags="-d -s -w" -o sleepy \
 && echo "nobody:x:65534:65534:nobody:/:/sbin/nologin" > passwd

FROM scratch

COPY --from=0 /root/passwd /etc/passwd
COPY --from=0 /root/sleepy /sleepy

USER nobody

EXPOSE 1234

ENTRYPOINT ["/sleepy"]
