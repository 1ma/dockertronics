FROM busybox

WORKDIR /tmp

COPY conf.d/* conf.d/
COPY mysql.conf.d/* mysql.conf.d/

RUN chmod -R 644 conf.d/* mysql.conf.d/*


FROM mysql:8.0

ENV TERM=xterm

COPY --from=0 /tmp/conf.d/*       /etc/mysql/conf.d/
COPY --from=0 /tmp/mysql.conf.d/* /etc/mysql/conf.d/
