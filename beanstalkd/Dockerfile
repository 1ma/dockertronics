FROM 1maa/alpine:3.5

RUN apk add --no-cache beanstalkd

USER beanstalk

EXPOSE 11300

CMD ["/usr/bin/beanstalkd"]
