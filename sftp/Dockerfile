FROM alpine:3.22

COPY key/id_rsa.pub /authorized_keys

RUN apk add --no-cache \
    openssh \
    tini \
 && adduser -D -H -h /sftp -s /sbin/nologin sftp \
 && echo 'root:root' | chpasswd \
 && echo 'sftp:sftp' | chpasswd \
 && mkdir -p /jail/sftp \
 && chmod 600 /authorized_keys \
 && chown sftp:sftp /authorized_keys /jail/sftp

COPY ssh/* /etc/ssh/

RUN chmod 400 /etc/ssh/ssh_host_*

VOLUME ["/jail/sftp"]

EXPOSE 22

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/sbin/sshd", "-D"]
