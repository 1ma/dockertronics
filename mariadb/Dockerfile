FROM busybox

WORKDIR /tmp

COPY conf.d/* conf.d/

RUN chmod -R 644 conf.d/*


FROM mariadb:10.6

ENV TERM=xterm

COPY --from=0 /tmp/conf.d/* /etc/mysql/conf.d/
