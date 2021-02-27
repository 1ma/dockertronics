# 1maa/postgres:12-alpine

An extension of the official `postgres:13-alpine` image with a few additional, non-contrib extensions.


### Non-Contrib Extension List

- [pgTAP](https://github.com/theory/pgtap): A TAP-based unit testing framework.
- [postgres-json-schema](https://github.com/gavinwahl/postgres-json-schema): Allows validation of Json Schemas against JSONB columns.
- [postGIS](http://postgis.net): Spatial and Geographic objects for PostgreSQL.


### Configuration tweaks

- `log_statement = 'all'`


## 1maa/postgres:12-src

An experimental image of Postgres 13.2 built from source, also based on Alpine Linux.
It is much smaller than the first one I built, but it still doesn't have any of the above extensions.
In the future I'd like to replace `1maa/postgres:13-alpine` with this one.

```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
1maa/postgres       12-src              dc3cd912f5aa        5 days ago          28.6MB
1maa/postgres       12-alpine           77d80a5dc1c7        5 days ago          418MB
```
