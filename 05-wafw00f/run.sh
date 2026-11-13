#!/usr/bin/env bash
# Step 5: fingerprint the WAF with wafw00f
set -euo pipefail
cd "$(dirname "$0")/.."; source config.env
command -v python3 >/dev/null || { echo "python3 required"; exit 1; }
if [ ! -d 05-wafw00f/.venv ]; then
  python3 -m venv 05-wafw00f/.venv || { echo "Try: sudo apt install -y python3-venv"; exit 1; }
  05-wafw00f/.venv/bin/pip install -q --upgrade pip wafw00f
fi
mkdir -p reports
05-wafw00f/.venv/bin/wafw00f -a -v "$WAF_URL" | tee "reports/wafw00f-$(date +%Y%m%d-%H%M%S).txt"
echo
echo "Note: SafeLine may show as 'SafeLine (Chaitin Tech.)' or as a generic WAF - both mean it is detected/blocking."
