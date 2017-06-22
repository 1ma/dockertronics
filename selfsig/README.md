# Self-Signed Certificate Generator

This image is meant to generate wildcard self-signed certificates for development (i.e. nginx over HTTPS).
When run, it creates a self-signed wildcard certificate and private key in the container's `/tmp` directory.

## Usage

### Manual generation

```bash
$ docker run --rm -it -e FQDN=domain.tld -v $(pwd):/tmp 1maa/selfsig
Generating a 4096 bit RSA private key
..........................................+++
...........+++
writing new private key to '/tmp/domain.tld.key'
-----

$ ls -l
-rw-r--r-- 1 root   root    891 jun 21 17:02 domain.tld.crt
-rw-r--r-- 1 root   root   1704 jun 21 17:02 domain.tld.key
```

### EnvVar list

| Name | Default Value |
|------|---------------|
| ALGO | rsa           |
| BITS | 4096          |
| FQDN | example.com   |

### Multistage build

```Dockerfile
FROM 1maa/selfsig

ENV FQDN=domain.tld

RUN openssl req -x509 -nodes -days 3650 -newkey ${ALGO}:${BITS} -keyout /tmp/${FQDN}.key -out /tmp/${FQDN}.crt -subj "/CN=*.${FQDN}"


FROM nginx:1.13-alpine

COPY --from=0 /tmp/ /etc/nginx/ssl/
```
