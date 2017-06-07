FROM 1maa/alpine:3.6

RUN apk add --no-cache h2o \
 && mkdir /etc/h2o \
 && mv /etc/h2o.conf /etc/h2o/h2o.conf \
 && ln -sf /dev/stdout /var/log/h2o/access.log \
 && ln -sf /dev/stderr /var/log/h2o/error.log

EXPOSE 80 443

CMD ["/usr/bin/h2o", "-c", "/etc/h2o/h2o.conf", "-m", "master"]
