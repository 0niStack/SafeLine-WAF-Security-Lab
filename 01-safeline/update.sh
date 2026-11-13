#!/usr/bin/env bash
# Update SafeLine (new releases every 2-3 weeks)
set -euo pipefail
cd "$(dirname "$0")/.."; source config.env
F=""; for n in compose.yaml docker-compose.yml; do [ -f "$SAFELINE_DIR/$n" ] && F="$SAFELINE_DIR/$n" && break; done
[ -n "$F" ] || { echo "No compose file in $SAFELINE_DIR"; exit 1; }
docker compose -f "$F" pull
docker compose -f "$F" up -d
