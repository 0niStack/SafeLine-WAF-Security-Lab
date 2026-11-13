#!/usr/bin/env bash
# Show SafeLine containers and dashboard reachability
cd "$(dirname "$0")/.."; source config.env
docker ps --format 'table {{.Names}}\t{{.Status}}' | grep -E 'NAMES|safeline' || echo "No SafeLine containers running"
echo
code=$(curl -sk -o /dev/null -w '%{http_code}' --max-time 5 https://127.0.0.1:9443 || true)
echo "Dashboard https://127.0.0.1:9443 -> HTTP ${code:-none}"
