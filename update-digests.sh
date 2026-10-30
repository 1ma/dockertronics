#!/usr/bin/env bash

# Refreshes the image digests pinned in a Docker Bake file. Each pin must carry
# the Docker Hub image to track in a trailing comment, for instance:
#   default = "sha256:..." # alpine:3.24
#
# A new digest is only written once the linux/amd64 and linux/arm64 variants it
# contains (at least one is required) have been in the registry for at least
# the cooldown period, to give malicious images time to be detected. Pushes of
# other platforms are ignored, as they also change the digest but never end up
# in our builds.
#
# Usage: update-digests.sh [cooldown_hours] [bake_file]
#   cooldown_hours: 72 by default, 0 disables the cooldown
#   bake_file:      docker-bake.hcl in the current directory by default

set -euo pipefail

COOLDOWN_HOURS="${1:-72}"
BAKE_FILE="${2:-docker-bake.hcl}"

if [[ $# -gt 2 || ! "$COOLDOWN_HOURS" =~ ^[0-9]+$ ]]; then
  echo "Usage: $0 [cooldown_hours] [bake_file]" >&2
  exit 1
fi

if [[ ! -f "$BAKE_FILE" ]]; then
  echo "$BAKE_FILE: file not found" >&2
  exit 1
fi

updated=0
held=0
total=0

while read -r current ref; do
  if [[ ! "$ref" =~ ^([a-z0-9_-]+/)?[a-z0-9._-]+:[A-Za-z0-9._-]+$ ]]; then
    echo "$ref: not a Docker Hub image" >&2
    exit 1
  fi

  repo=${ref%%:*}
  [[ "$repo" == */* ]] || repo="library/$repo"

  # last_pushed is assigned by the registry, unlike the created dates in the
  # image config and annotations, which the image publisher can forge.
  response=$(curl -fsS --max-time 30 "https://hub.docker.com/v2/repositories/${repo}/tags/${ref##*:}")
  digest=$(jq -r '.digest // empty' <<< "$response")
  pushed=$(jq -r '
    [.images[]? | select(.os == "linux" and (.architecture == "amd64" or .architecture == "arm64")) | .last_pushed]
    | if length > 0 and all(. != null) then max else empty end
  ' <<< "$response")

  if [[ ! "$digest" =~ ^sha256:[0-9a-f]{64}$ || -z "$pushed" ]]; then
    echo "$ref: missing digest or amd64/arm64 last_pushed in Docker Hub response" >&2
    exit 1
  fi

  age=$(($(date +%s) - $(date -d "$pushed" +%s)))
  total=$((total + 1))

  if [[ "$digest" == "$current" ]]; then
    printf '%-20s unchanged\n' "$ref"
  elif ((age < 10#$COOLDOWN_HOURS * 3600)); then
    printf '%-20s cooldown (pushed %dh ago): %s -> %s\n' "$ref" "$((age / 3600))" "$current" "$digest"
    held=$((held + 1))
  else
    sed -i -E "s|sha256:[0-9a-f]{64}(\" # ${ref})\$|${digest}\1|" "$BAKE_FILE"
    printf '%-20s %s -> %s\n' "$ref" "$current" "$digest"
    updated=$((updated + 1))
  fi
done < <(sed -nE 's/.*default = "(sha256:[0-9a-f]{64})" # (\S+)$/\1 \2/p' "$BAKE_FILE")

printf '\n%d of %d digests updated, %d held by cooldown\n' "$updated" "$total" "$held"
