# docker-compose

A docker image with the Docker client and `docker-compose`. If you spin up an `1maa/docker-compose`
container with a host volume mapped to `/var/run/docker.sock`, you can control the host's Docker
server from inside the container.

```yaml
version: "2"
services:
    compose:
        image: 1maa/docker-compose
        volumes:
          - /var/run/docker.sock:/var/run/docker.sock
```
