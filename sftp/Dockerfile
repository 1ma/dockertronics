FROM 1maa/alpine:3.5

COPY id_rsa.pub /authorized_keys

RUN apk add --no-cache \
    openssh \
 && ssh-keygen -A \
 && adduser -D -h /sftp -s /sbin/nologin sftp \
 && echo 'sftp:sftp' | chpasswd \
 && mkdir -p /jail/sftp \
 && chmod 600 /authorized_keys \
 && chown sftp:sftp /authorized_keys /jail/sftp

COPY sshd_config /etc/ssh/sshd_config

VOLUME /jail/sftp

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
