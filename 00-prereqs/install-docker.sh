#!/usr/bin/env bash
# Step 0b: install Docker (skip if already installed)
set -euo pipefail
if command -v docker >/dev/null; then echo "Docker already installed"; else curl -fsSL https://get.docker.com | bash; fi
systemctl enable --now docker 2>/dev/null || true
docker --version
docker compose version
