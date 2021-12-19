#!/usr/bin/env sh

/usr/local/pgsql/bin/initdb --locale=${LANG} --data-checksums -D /var/lib/postgres/data

/usr/local/pgsql/bin/postgres         \
  -D /var/lib/postgres/data           \
                                      \
  -c listen_addresses=0.0.0.0         \
  -c port=5432                        \
                                      \
  -c checkpoint_completion_target=0.9 \
  -c default_statistics_target=100    \
  -c effective_cache_size=4GB         \
  -c effective_io_concurrency=200     \
  -c log_statement=all                \
  -c maintenance_work_mem=1GB         \
  -c max_connections=20               \
  -c max_wal_size=2GB                 \
  -c min_wal_size=100MB               \
  -c random_page_cost=1.1             \
  -c shared_buffers=1GB               \
  -c wal_buffers=16MB                 \
  -c work_mem=21845kB
