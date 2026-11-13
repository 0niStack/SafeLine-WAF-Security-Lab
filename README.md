# safeline-waf-lab

Deploy the SafeLine WAF, protect a deliberately vulnerable app (DVWA), and measure how well the WAF blocks attacks.
Run the numbered folders one by one.

```
Attacker/Scanner ──► SafeLine (Tengine :8088) ──► DVWA (127.0.0.1:8081)
                      │ Detector (semantic analysis)
                      └ Dashboard :9443
```

## Requirements
Linux (Ubuntu 20.04+, Debian 11+, CentOS 7+), Docker 20.10.6+, Compose 2.0.0+, 1 CPU / 1 GB RAM / 5 GB disk.
Ports used: 9443 (dashboard), 8088 (protected site), 8081 (DVWA, localhost only). Edit `config.env` to change.

## Run order

| # | Folder | Command | What it does |
|---|--------|---------|--------------|
| 0 | `00-prereqs` | `bash 00-prereqs/check.sh` (and `sudo bash 00-prereqs/install-docker.sh` if needed) | Checks CPU/RAM/disk/Docker/ports |
| 1 | `01-safeline` | `sudo bash 01-safeline/install.sh` then `bash 01-safeline/status.sh` | Installs SafeLine (2-3 min) |
| 2 | `02-dvwa` | `bash 02-dvwa/up.sh` | Starts DVWA on 127.0.0.1:8081 |
| 3 | `03-configure-site` | follow its `README.md`, then `bash 03-configure-site/verify.sh` | Add site `*` : 8088 -> `http://127.0.0.1:8081` in the dashboard |
| 4 | `04-baseline-test` | `bash 04-baseline-test/run.sh` | 14 payloads, direct vs via WAF, with a blocked/passed table |
| 5 | `05-wafw00f` | `bash 05-wafw00f/run.sh` | Fingerprints the WAF |
| 6 | `06-gotestwaf` | `bash 06-gotestwaf/run.sh` | Full scored test (true/false positives), PDF/HTML report |
| 7 | `07-cleanup` | `bash 07-cleanup/cleanup.sh` | Tears everything down |

Shortcut: `make check`, `make safeline`, `make dvwa`, `make verify`, `make test`, `make fingerprint`, `make gotestwaf`, `make cleanup`.

## Reading the results
- Step 4: "Direct" should be 200/302 (DVWA accepts the attack); "WAF" should be **403** for every attack and 200 for the clean request.
- Anything marked `PASSED <-- review` is a bypass: check Attack Logs, raise the protection level, or add a custom rule.
- Step 6 produces a score; run it again after tuning to compare.

## Day-one hardening (after tests)
Rate limiting (Rules), geo-blocking (IP Groups), bot protection (login/forms), SSL / Let's Encrypt auto-renewal.

## Keeping SafeLine updated
`bash 01-safeline/update.sh` (releases every 2-3 weeks).

## Safety notes
- Only test systems you own. DVWA is vulnerable by design; it is bound to localhost, keep it behind the WAF.
- `install.sh` runs the official remote installer as root - read it first if that matters for your environment.
- The SafeLine dashboard uses a self-signed certificate (hence `curl -k`).
- Troubleshooting: 502 from the WAF = wrong upstream; connection refused on 8088 = site not saved or firewall; SQLi not blocked = site not in blocking mode.
