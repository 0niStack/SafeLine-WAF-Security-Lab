#!/usr/bin/env bash
# Step 6: full WAF effectiveness test with Wallarm GoTestWAF (takes a few minutes)
set -euo pipefail
cd "$(dirname "$0")/.."; source config.env
mkdir -p reports/gotestwaf
docker run --rm --network host \
  -v "$PWD/reports/gotestwaf:/app/reports" \
  wallarm/gotestwaf \
  --url="$WAF_URL" \
  --noEmailReport
echo
echo ">> Reports (PDF/HTML/JSON) are in: reports/gotestwaf/"
echo ">> Check the true-positive vs false-positive scores, then tune SafeLine."
