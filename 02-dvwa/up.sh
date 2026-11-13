#!/usr/bin/env bash
# Step 2: start the intentionally vulnerable DVWA app
set -euo pipefail
cd "$(dirname "$0")"; source ../config.env
export DVWA_PORT
docker compose up -d
echo ">> Waiting for DVWA ..."
for i in $(seq 1 30); do
  c=$(curl -s -o /dev/null -w '%{http_code}' "$DIRECT_URL/login.php" || true)
  [ "$c" = "200" ] && break; sleep 2
done
echo ">> DVWA direct URL: $DIRECT_URL  (HTTP $c)"
echo ">> First time only: open $DIRECT_URL/setup.php and click 'Create / Reset Database'"
echo ">> Login: admin / password   (set Security level to LOW in DVWA Security)"
echo "!! WARNING: DVWA is vulnerable by design. Never expose it directly to the internet."
