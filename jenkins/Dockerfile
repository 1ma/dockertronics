FROM 1maa/alpine:3.4

ENV JENKINS_VERSION 2.7.1

RUN apk add --no-cache \
    openjdk8-jre \
    ttf-dejavu

ADD http://mirrors.jenkins-ci.org/war-stable/$JENKINS_VERSION/jenkins.war /root

WORKDIR /root

CMD ["/usr/bin/java", "-jar", "jenkins.war"]
