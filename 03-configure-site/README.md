# Step 3 - Protect DVWA with SafeLine (manual, ~2 minutes)

1. Open `https://<server-ip>:9443`, log in, and finish TOTP setup (QR code + any authenticator app).
2. **Sites -> Add Site** (the exact menu names may differ slightly between versions):

| Field            | Value                                                     |
|------------------|-----------------------------------------------------------|
| Domain           | `*`  (matches any Host header, so scanners work with IP)  |
| Port             | `8088`  (must equal `WAF_PORT` in `config.env`)           |
| Upstream server  | `http://127.0.0.1:8081`  (DVWA)                            |
| SSL              | off for this lab                                          |

3. Save. Protection starts immediately - no rules to write.
4. Check it works:

```bash
curl -I http://127.0.0.1:8088/login.php     # should return 200 via the WAF
bash 03-configure-site/verify.sh
```

If port 8088 is not reachable from outside, open it in your firewall / cloud security group.
If the upstream is not reachable from SafeLine, try the host's private IP instead of 127.0.0.1.

## Day-one hardening (after the tests)
- Rate limiting: per-IP limits under Rules
- Geo-blocking: block countries you don't serve under IP Groups
- Bot protection: enable for login pages and forms
- SSL: upload a certificate or enable Let's Encrypt auto-renewal
