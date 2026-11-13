#!/usr/bin/env bash
cd "$(dirname "$0")"; source ../config.env; export DVWA_PORT
docker compose down
