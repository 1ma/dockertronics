#!/usr/bin/env ash

# Only initialize the database directory once in the lifetime
# of the container, when $PGDATA/PG_VERSION still does not exist
if [ ! -f /var/lib/postgres/data/PG_VERSION ]; then
  initdb                                    \
    --data-checksums                        \
    --locale="${LANG}"                      \
    --pgdata /var/lib/postgres/data         \
    --pwfile=/run/secrets/POSTGRES_PASSWORD \
    --username="${POSTGRES_USER}"

  # Allow authenticated connections from other Docker containers
  echo "host    all             all             all                     scram-sha-256" >> /var/lib/postgres/data/pg_hba.conf

  # Postgres needs to be momentarily brought up in the background to be
  # able to create a non-default database or execute SQL init scripts
  if [ "$POSTGRES_DB" != "postgres" ] || [ -n "$(ls -A /docker-entrypoint-initdb.d)" ]; then
    pg_ctl -D /var/lib/postgres/data --wait start

    if [ "$POSTGRES_DB" != "postgres" ]; then
      createdb                        \
        --username "${POSTGRES_USER}" \
        --owner "${POSTGRES_USER}"    \
        --echo                        \
        "${POSTGRES_DB}"
    fi

    for f in /docker-entrypoint-initdb.d/*; do
      case "$f" in
        *.sql)    echo "running $f";                  psql -v ON_ERROR_STOP=1 --echo-all --dbname "${POSTGRES_DB}" --username "${POSTGRES_USER}" -f "$f" || exit 1; echo ;;
        *.sql.gz) echo "running $f"; gunzip -c "$f" | psql -v ON_ERROR_STOP=1 --echo-all --dbname "${POSTGRES_DB}" --username "${POSTGRES_USER}"         || exit 1; echo ;;
        *.sql.xz) echo "running $f"; xzcat "$f"     | psql -v ON_ERROR_STOP=1 --echo-all --dbname "${POSTGRES_DB}" --username "${POSTGRES_USER}"         || exit 1; echo ;;
        *)        echo "ignoring $f" ;;
      esac
    done

    pg_ctl -D /var/lib/postgres/data --wait --mode fast stop
  fi
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
  -c huge_pages=off                   \
  -c log_statement=all                \
  -c maintenance_work_mem=1GB         \
  -c max_connections=20               \
  -c max_wal_size=2GB                 \
  -c min_wal_size=100MB               \
  -c random_page_cost=1.1             \
  -c shared_buffers=1GB               \
  -c wal_buffers=16MB                 \
  -c work_mem=21845kB
