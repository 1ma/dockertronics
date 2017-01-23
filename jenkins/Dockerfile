FROM 1maa/alpine:3.5

ENV JENKINS_VERSION  2.7.2
ENV JENKINS_ROOT_DIR /var/jenkins
ENV JENKINS_HOME     $JENKINS_ROOT_DIR/data

RUN apk add --no-cache \
    docker \
    openjdk8-jre \
    ttf-dejavu \
 && mkdir -p $JENKINS_ROOT_DIR \
 && wget http://mirrors.jenkins-ci.org/war-stable/$JENKINS_VERSION/jenkins.war -O $JENKINS_ROOT_DIR/jenkins.war

VOLUME $JENKINS_HOME

EXPOSE 8080

CMD /usr/bin/java -jar $JENKINS_ROOT_DIR/jenkins.war
