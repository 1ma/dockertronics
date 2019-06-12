FROM 1maa/alpine:3.9

WORKDIR /tmp

RUN apk add --no-cache \
    alpine-sdk \
 && git clone --depth=1 https://github.com/beanstalkd/beanstalkd \
 && cd beanstalkd \
 && sed -i 's@sys/fcntl.h@fcntl.h@' sd-daemon.c \
 && sed -i 's@-g\\@-O3 -march=x86-64@' Makefile \
 && make \
 && make check


FROM 1maa/alpine:3.9

COPY --from=0 /tmp/beanstalkd/beanstalkd /usr/bin/beanstalkd

RUN adduser -S -D -H -h /dev/null -s /sbin/nologin -G daemon beanstalkd

EXPOSE 11300

CMD ["/usr/bin/beanstalkd", "-u", "beanstalkd", "-V"]
