# 1maa/postgres:11-alpine

An extension of the official `postgres:11-alpine` image with a few additional, non-contrib extensions.

### Non-Contrib Extension List

- [pgTAP](https://github.com/theory/pgtap): A TAP-based unit testing framework.
- [postgres-json-schema](https://github.com/gavinwahl/postgres-json-schema): Allows validation of Json Schemas against JSONB columns.
- [postGIS](http://postgis.net): Spatial and Geographic objects for PostgreSQL.

### Configuration tweaks

- `log_statement = 'all'`
