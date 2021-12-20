#!/usr/bin/env ash

# Only initialize the database directory once in the lifetime
# of the container, when $PGDATA/PG_VERSION still does not exist
if [ ! -f /var/lib/postgres/data/PG_VERSION ]; then
  initdb                                    \
    --data-checksums                        \
    --locale="${LANG}"                      \
    --pgdata /var/lib/postgres/data         \
    --pwfile=<(echo "${POSTGRES_PASSWORD}") \
    --username="${POSTGRES_USER}"

  # If $POSTGRES_DB is not the default value create that database for user $POSTGRES_USER
  # Postgres needs to be momentarily brought up in the background to be able to create a new database
  if [ 'postgres' != "${POSTGRES_DB}" ]; then
    pg_ctl -D /var/lib/postgres/data start

    createdb                        \
      --username "${POSTGRES_USER}" \
      --owner "${POSTGRES_USER}"    \
      --echo                        \
      "${POSTGRES_DB}"

    # TODO: execute any .sql files in /docker-entrypoint-init.d

    pg_ctl -D /var/lib/postgres/data -m fast stop
  fi

  # Allow authenticated connections from other Docker containers
  echo "host    all             all             all                     scram-sha-256" >> /var/lib/postgres/data/pg_hba.conf
fi

# Proper startup with the *:5432 binding and the rest of PGTune settings
# exec is needed for Postgres to be able receive the stop signal
exec postgres                         \
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
