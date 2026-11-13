#!/usr/bin/env bash
# Confirms DVWA is reachable through the WAF and that a basic SQLi is blocked
cd "$(dirname "$0")/.."; source config.env
d=$(curl -s -o /dev/null -w '%{http_code}' --max-time 10 "$DIRECT_URL/login.php")
w=$(curl -s -o /dev/null -w '%{http_code}' --max-time 10 "$WAF_URL/login.php")
a=$(curl -s -o /dev/null -w '%{http_code}' --max-time 10 -G --data-urlencode "id=1' OR '1'='1" "$WAF_URL/")
echo "Direct DVWA        : HTTP $d  (expect 200)"
echo "Via WAF, clean     : HTTP $w  (expect 200)"
echo "Via WAF, SQLi      : HTTP $a  (expect 403)"
[ "$w" = "200" ] && [ "$a" = "403" ] && echo "RESULT: WAF is protecting DVWA" || { echo "RESULT: check site config (port/upstream)"; exit 1; }
