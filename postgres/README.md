# 1maa/postgres:15-alpine

An extension of the official `postgres:15-alpine` image with a few additional, non-contrib extensions.


### Non-Contrib Extension List

- [pgTAP](https://github.com/theory/pgtap): A TAP-based unit testing framework.
- [postgres-json-schema](https://github.com/gavinwahl/postgres-json-schema): Allows validation of Json Schemas against JSONB columns.
- [postGIS](http://postgis.net): Spatial and Geographic objects for PostgreSQL.


### Configuration tweaks

The tweaks were guided by the [PGTune utility](https://pgtune.leopard.in.ua/) assuming Postgres v15, Linux OS,
a Desktop Application workload (i.e. developer machine), 16GiB of RAM and SSD storage.

In addition `log_statement` is set to `'all'` to ease in troubleshooting issues.

```
# DB Version: 15
# OS Type: linux
# DB Type: desktop
# Total Memory (RAM): 16 GB
# Data Storage: ssd

max_connections = 20
shared_buffers = 1GB
effective_cache_size = 4GB
maintenance_work_mem = 1GB
checkpoint_completion_target = 0.9
wal_buffers = 16MB
default_statistics_target = 100
random_page_cost = 1.1
effective_io_concurrency = 200
work_mem = 21845kB
min_wal_size = 100MB
max_wal_size = 2GB
```


## 1maa/postgres:15-src

An experimental image of Postgres built from source, also based on Alpine Linux.
It is much smaller than the first one I built, but it still doesn't have any of the above extensions.
In the future I'd like to replace `1maa/postgres:15-alpine` with this one.

```
REPOSITORY      TAG         IMAGE ID       CREATED          SIZE
1maa/postgres   15-src      1b65cbdd4a79   2 minutes ago    40.5MB
1maa/postgres   15-alpine   1ea38ef5f1a8   6 minutes ago    1.23GB
```
