FROM 1maa/alpine:3.10

WORKDIR /tmp

RUN apk add --no-cache \
    build-base \
    git \
    upx \
 && wget https://github.com/krallin/tini/releases/download/v0.18.0/tini-static-amd64 -O tini \
 && chmod +x tini \
 && git clone --depth=1 https://github.com/beanstalkd/beanstalkd \
 && cd beanstalkd \
 && sed -i 's@sys/fcntl.h@fcntl.h@' sd-daemon.c \
 && sed -i 's@-g\\@-O3 -march=x86-64@' Makefile \
 && sed -i 's@LDFLAGS=@LDFLAGS=-static@' Makefile \
 && make \
 && make check \
 && upx beanstalkd ../tini


FROM busybox

COPY --from=0 /tmp/beanstalkd/beanstalkd /root/beanstalkd
COPY --from=0 /tmp/tini                  /root/tini

RUN mkdir /root/etc \
 && echo "nobody:x:65534:65534:nobody:/:/sbin/nologin" > /root/etc/passwd


FROM scratch

COPY --from=1 /root /

USER nobody

EXPOSE 11300

CMD ["/tini", "--", "/beanstalkd", "-V"]
