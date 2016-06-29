FROM 1maa/alpine:edge

RUN apk add --no-cache beanstalkd

USER beanstalk

EXPOSE 11300

CMD ["/usr/bin/beanstalkd"]
