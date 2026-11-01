#!/bin/sh

exec /usr/local/bin/miner \
  --cli="bitcoin-cli ${CLI_CMD_ARGS}" \
  generate \
  --descriptor "${MINING_XPUB}" \
  --grind-cmd="bitcoin-util grind" \
  --max-interval "${MAX_INTERVAL}" \
  --min-nbits \
  --ongoing
