FROM mariadb:10.4

ENV TERM=xterm

COPY conf.d/* /etc/mysql/conf.d/

RUN chmod 644 /etc/mysql/conf.d/*.cnf
