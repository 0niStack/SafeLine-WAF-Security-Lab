.PHONY: check docker safeline status dvwa verify test fingerprint gotestwaf cleanup
check:       ; bash 00-prereqs/check.sh
docker:      ; sudo bash 00-prereqs/install-docker.sh
safeline:    ; sudo bash 01-safeline/install.sh
status:      ; bash 01-safeline/status.sh
dvwa:        ; bash 02-dvwa/up.sh
verify:      ; bash 03-configure-site/verify.sh
test:        ; bash 04-baseline-test/run.sh
fingerprint: ; bash 05-wafw00f/run.sh
gotestwaf:   ; bash 06-gotestwaf/run.sh
cleanup:     ; bash 07-cleanup/cleanup.sh
