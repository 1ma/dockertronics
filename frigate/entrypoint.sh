#!/bin/sh
set -e

FRIGATE_HOME="/home/frigate/.frigate"

NETWORK=""
prev=""
for arg in "$@"; do
  if [ "$prev" = "--network" ] || [ "$prev" = "-n" ]; then
    NETWORK="$arg"
    break
  fi
  prev="$arg"
done

case "$NETWORK" in
  ""|mainnet)
    CONF_DIR="$FRIGATE_HOME"
    ;;
  *)
    CONF_DIR="$FRIGATE_HOME/$NETWORK"
    ;;
esac

mkdir -p "$CONF_DIR"
envsubst < /tmp/config.template.toml > "$CONF_DIR/config.toml"

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- /opt/frigate/bin/frigate "$@"
fi

exec "$@"
