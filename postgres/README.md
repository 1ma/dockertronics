# 1maa/postgres:17-alpine

A PostgreSQL image built from source with the [PostGIS] and [pgTAP] extensions.

### POSTGRES_PASSWORD

The `POSTGRES_PASSWORD` environment variable has been removed due to [security concerns].

Now it has to be passed to the container as a [secret] named `POSTGRES_PASSWORD`.

To define the secret as an environment variable in the host machine:

```yaml
services:
  postgres:
    image: 1maa/postgres:17-alpine
    environment:
      - POSTGRES_DB=db_name
      - POSTGRES_USER=user_name
    ports:
      - "127.0.0.1:5432:5432"
    secrets:
      - POSTGRES_PASSWORD

secrets:
  POSTGRES_PASSWORD:
    environment: POSTGRES_PASSWORD
```
```shell
$ POSTGRES_PASSWORD=user_password docker compose up -d
```

To store the secret in a local file on the host machine:

```yaml
services:
  postgres:
    image: 1maa/postgres:17-alpine
    environment:
      - POSTGRES_DB=db_name
      - POSTGRES_USER=user_name
    ports:
      - "127.0.0.1:5432:5432"
    secrets:
      - POSTGRES_PASSWORD

secrets:
  POSTGRES_PASSWORD:
    file: ./secret.txt
```
```shell
$  echo "user_password" > secret.txt
$ docker compose up -d
```


### Configuration tweaks

The tweaks were guided by the [PGTune utility](https://pgtune.leopard.in.ua/) assuming Postgres v16, Linux OS,
a Desktop Application workload (i.e. developer machine), 16GiB of RAM and SSD storage.

In addition `log_statement` is set to `'all'` to ease in troubleshooting issues.

```
# DB Version: 16
# OS Type: linux
# DB Type: desktop
# Total Memory (RAM): 16 GB
# Data Storage: ssd

checkpoint_completion_target = 0.9
default_statistics_target = 100
effective_cache_size = 4GB
effective_io_concurrency = 200
huge_pages = off
maintenance_work_mem = 1GB
max_connections = 20
max_wal_size = 2GB
min_wal_size = 100MB
random_page_cost = 1.1
shared_buffers = 1GB
wal_buffers = 16MB
work_mem = 21845kB
```

[PostGIS]: https://postgis.net/
[pgTAP]: https://pgtap.org/
[security concerns]: https://docs.docker.com/reference/build-checks/secrets-used-in-arg-or-env/
[secret]: https://docs.docker.com/reference/compose-file/secrets/
