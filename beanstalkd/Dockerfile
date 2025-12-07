FROM alpine:3.22

WORKDIR /tmp

ADD https://github.com/beanstalkd/beanstalkd/archive/master.tar.gz .

RUN apk add --no-cache \
    build-base \
    file \
    pkgconf \
    upx \
 && tar zxf master.tar.gz \
 && cd beanstalkd-master \
 && sed -i 's@-g@-Os@' Makefile \
 && sed -i 's@LDFLAGS?=@LDFLAGS?=-s -static@' Makefile \
 && make \
 && make check \
 && file beanstalkd \
 && upx --lzma beanstalkd \
 && file beanstalkd


FROM busybox

COPY --from=0 /tmp/beanstalkd-master/beanstalkd /root/beanstalkd

RUN mkdir /root/etc \
 && echo "nobody:x:65534:65534:nobody:/:/sbin/nologin" > /root/etc/passwd


FROM scratch

COPY --from=1 /root /

USER nobody

EXPOSE 11300

CMD ["/beanstalkd", "-V"]
