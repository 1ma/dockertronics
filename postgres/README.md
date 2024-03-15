# 1maa/postgres:16-alpine

A PostgreSQL image built from source with the [PostGIS] and [pgTAP] extensions.

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
