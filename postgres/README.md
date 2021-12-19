# 1maa/postgres:14-alpine

An extension of the official `postgres:14-alpine` image with a few additional, non-contrib extensions.


### Non-Contrib Extension List

- [pgTAP](https://github.com/theory/pgtap): A TAP-based unit testing framework.
- [postgres-json-schema](https://github.com/gavinwahl/postgres-json-schema): Allows validation of Json Schemas against JSONB columns.
- [postGIS](http://postgis.net): Spatial and Geographic objects for PostgreSQL.


### postgresql.conf tweaks

- `shared_buffers = 32MB -> 2GB`
- `work_mem = 4MB -> 128MB`
- `maintenance_work_mem = 64MB -> 512MB`
- `effective_io_concurrency = 1 -> 2`
- `random_page_cost = 4.0 -> 1.0`
- `log_statement = 'none' -> 'all'`


## 1maa/postgres:14-src

An experimental image of Postgres 14 built from source, also based on Alpine Linux.
It is much smaller than the first one I built, but it still doesn't have any of the above extensions.
In the future I'd like to replace `1maa/postgres:14-alpine` with this one.

```
REPOSITORY      TAG         IMAGE ID       CREATED       SIZE
1maa/postgres   14-src      b89c6695d84a   3 weeks ago   34.9MB
1maa/postgres   14-alpine   9391542d695e   5 hours ago   563MB
```
