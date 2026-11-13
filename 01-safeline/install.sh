#!/usr/bin/env bash
# Step 1: install SafeLine WAF (official installer, ~2-3 minutes)
set -euo pipefail
[ "$(id -u)" -eq 0 ] || { echo "Run as root: sudo bash $0"; exit 1; }
echo ">> Running the official SafeLine installer (downloads and executes a remote script)"
bash -c "$(curl -fsSLk https://waf.chaitin.com/release/latest/manager.sh)" -- --en
echo
echo ">> Done. Dashboard: https://<server-ip>:9443  (set up TOTP on first login)"
echo ">> Next: bash 01-safeline/status.sh"
