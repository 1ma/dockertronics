# beanstalkd

## what's in the mistery meat?

A beanstalkd 1.10 binary compiled inside an ```1maa/alpine:3.4``` container and later copied over here.

```sh
$ docker run -it --rm 1maa/alpine:3.4 sh
f85beb0bcb16:/# apk add --no-cache alpine-sdk wget
f85beb0bcb16:/# wget https://github.com/kr/beanstalkd/archive/v1.10.tar.gz
f85beb0bcb16:/# tar zxf v1.10.tar.gz
f85beb0bcb16:/# cd beanstalkd-1.10
f85beb0bcb16:/beanstalkd-1.10# sed -i 's@#include <sys/fcntl.h>@#include <fcntl.h>@' ./sd-daemon.c # fixes a compilation error related to musl
f85beb0bcb16:/beanstalkd-1.10# make CFLAGS=-O3
```
