FROM 1maa/alpine:3.6

RUN apk add --no-cache varnish

COPY default.vcl /etc/varnish/default.vcl

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/varnishd", "-F", "-a", "0.0.0.0:80", "-a", "0.0.0.0:443", "-f", "/etc/varnish/default.vcl"]
