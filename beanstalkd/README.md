# Beanstalkd


Lightweight beanstalkd image. `1maa/beanstalkd:latest` is a build of the
project's latest commit. There are also a few tagged releases, such as `1maa/beanstalkd:1.11`
that I occasionally build and push manually.

## Caveats

This image needs an `init` process to run smoothly. In particular beanstalkd ignores
signals when it runs as PID 1, so for instance it cannot be killed by pressing Ctrl+C
when it runs on the foreground.

`1maa/beanstalkd` images used to ship with a static build of [tini], but I've recently
learnt that tini is also embedded into Docker itself. So instead run them with the `--init` flag:

```bash
$ docker run --rm -it --init 1maa/beanstalkd:1.11
```

Or in a docker-compose.yml file (version 3.7 and above):

```yaml
version: 3.7

services:
  beanstalkd:
    image: 1maa/beanstalkd:1.11
    init: true
```


[tini]: https://github.com/krallin/tini
