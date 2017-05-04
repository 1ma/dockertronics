FROM 1maa/alpine:3.5

COPY key/id_rsa.pub /authorized_keys

RUN apk add --no-cache \
    openssh=7.4_p1-r0 \
 && adduser -D -h /sftp -s /sbin/nologin sftp \
 && echo 'sftp:sftp' | chpasswd \
 && mkdir -p /jail/sftp \
 && chmod 600 /authorized_keys \
 && chown sftp:sftp /authorized_keys /jail/sftp

COPY ssh/* /etc/ssh/

VOLUME /jail/sftp

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
