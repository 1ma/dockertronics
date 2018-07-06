FROM 1maa/alpine:3.7

RUN apk add --no-cache beanstalkd

EXPOSE 11300

CMD ["/usr/bin/beanstalkd", "-u", "beanstalk", "-V"]
