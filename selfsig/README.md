# Self-Signed Certificate Generator

This image is meant to generate wildcard self-signed certificates for development (i.e. nginx over HTTPS).
When it runs it creates a self-signed wildcard certificate and private key in the container's `/tmp` directory.

## Usage

### Manual generation

```bash
$ docker run -u $(id -u):$(id -g) --rm -it -e FQDN=domain.tld -v $(pwd):/tmp 1maa/selfsig:latest
Generating a 4096 bit RSA private key
..........................................+++
...........+++
writing new private key to '/tmp/domain.tld.key'
-----

$ ls -l
-rw-r--r--  1 user user 1814 feb 11 16:09 domain.tld.crt
-rw-------  1 user user 3272 feb 11 16:09 domain.tld.key
```

### EnvVar list

| Name | Default Value |
|------|---------------|
| ALGO | rsa           |
| BITS | 4096          |
| FQDN | example.com   |
