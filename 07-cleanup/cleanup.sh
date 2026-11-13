#!/usr/bin/env bash
# Step 7: tear the lab down
cd "$(dirname "$0")/.."; source config.env; export DVWA_PORT
echo ">> Stopping DVWA"; (cd 02-dvwa && docker compose down)
read -rp "Also stop SafeLine? [y/N] " a
if [[ "$a" =~ ^[Yy]$ ]]; then
  for n in compose.yaml docker-compose.yml; do
    [ -f "$SAFELINE_DIR/$n" ] && docker compose -f "$SAFELINE_DIR/$n" down && break
  done
fi
echo "Done. Reports are kept in ./reports"
