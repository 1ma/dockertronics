FROM 1maa/alpine:3.5

RUN apk add --no-cache \
    openssh \
 && ssh-keygen -A \
 && adduser -D -h /sftp -s /sbin/nologin sftp \
 && echo 'sftp:sftp' | chpasswd \
 && mkdir -p /jail/sftp \
 && chown sftp:sftp /jail/sftp

COPY sshd_config /etc/ssh/sshd_config

VOLUME /jail/sftp

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
