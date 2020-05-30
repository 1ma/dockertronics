FROM 1maa/alpine:3.12

WORKDIR /tmp

RUN apk add --no-cache \
    build-base \
    file \
    git \
    upx \
 && git clone --depth=1 https://github.com/beanstalkd/beanstalkd \
 && cd beanstalkd \
 && sed -i 's@-g@-Os -march=x86-64@' Makefile \
 && sed -i 's@LDFLAGS?=@LDFLAGS?=-s -static@' Makefile \
 && make \
 && make check \
 && file beanstalkd \
 && upx --lzma beanstalkd \
 && file beanstalkd


FROM busybox

COPY --from=0 /tmp/beanstalkd/beanstalkd /root/beanstalkd

RUN mkdir /root/etc \
 && echo "nobody:x:65534:65534:nobody:/:/sbin/nologin" > /root/etc/passwd


FROM scratch

COPY --from=1 /root /

USER nobody

EXPOSE 11300

CMD ["/beanstalkd", "-V"]
