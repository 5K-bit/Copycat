#!/usr/bin/env bash
# Destroy the Copycat lab and recreate it from the images. Touches only the "copycat"
# compose project (containers copycat-kali / copycat-target, network copycat-net).
# Usage: copycat-reset.sh [--rebuild]   (--rebuild also rebuilds images without cache)
set -euo pipefail
cd "$(dirname "$0")/.."
docker compose down --volumes --remove-orphans
if [[ "${1:-}" == "--rebuild" ]]; then docker compose build --no-cache; fi
docker compose up -d --build --force-recreate
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then p=$'\e[38;5;213m'; r=$'\e[0m'; else p=''; r=''; fi
printf '\n%s   /\\_/\\   ___\n  ( o.o ) |   |   <- the cup is back on the table.\n   > ^ <  |___|%s\n' "$p" "$r"
echo "Copycat is clean.  ssh copycat@127.0.0.1 -p 2222   (password: copycat)"
