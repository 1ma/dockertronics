FROM golang:alpine

COPY ./main.go /root/main.go

RUN cd ~ \
 && CGO_ENABLE=0 go build -tags netgo -v -ldflags="-d -s -w" -o sleepy

FROM scratch

COPY --from=0 /root/sleepy /sleepy

EXPOSE 1234

ENTRYPOINT ["/sleepy"]
