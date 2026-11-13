#!/usr/bin/env bash
# Step 0: verify the server meets SafeLine requirements
set -u
ok(){ echo "  [OK]   $*"; }; bad(){ echo "  [FAIL] $*"; FAIL=1; }
FAIL=0
echo "== Prerequisites =="
. /etc/os-release 2>/dev/null && echo "  OS: $PRETTY_NAME"
CPU=$(nproc); MEM=$(awk '/MemTotal/{printf "%.1f",$2/1024/1024}' /proc/meminfo)
DISK=$(df -BG --output=avail / | tail -1 | tr -dc '0-9')
[ "$CPU" -ge 1 ] && ok "CPU cores: $CPU" || bad "need >= 1 CPU core"
awk -v m="$MEM" 'BEGIN{exit !(m>=0.9)}' && ok "RAM: ${MEM} GB" || bad "need >= 1 GB RAM"
[ "$DISK" -ge 5 ] && ok "Free disk: ${DISK} GB" || bad "need >= 5 GB free disk"
if command -v docker >/dev/null; then ok "$(docker --version)"; else bad "docker missing -> run: sudo bash 00-prereqs/install-docker.sh"; fi
if docker compose version >/dev/null 2>&1; then ok "$(docker compose version)"; else bad "docker compose plugin missing"; fi
for p in 9443 8088 8081; do
  ss -ltn 2>/dev/null | grep -q ":$p " && bad "port $p already in use" || ok "port $p free"
done
exit $FAIL
