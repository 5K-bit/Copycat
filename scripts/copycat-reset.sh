#!/usr/bin/env bash
# Destroy the Copycat lab and recreate it from the images. Touches only the "copycat"
# compose project (containers copycat-kali / copycat-target, network copycat-net).
# Usage: copycat-reset.sh [--rebuild]   (--rebuild also rebuilds images without cache)
set -euo pipefail
cd "$(dirname "$0")/.."
. scripts/ui.sh
ui_banner
ui_run "Removing the old lab" docker compose down --volumes --remove-orphans
if [[ "${1:-}" == "--rebuild" ]]; then ui_run "Rebuilding images from scratch" docker compose build --no-cache; fi
ui_run "Recreating Copycat" docker compose up -d --build --force-recreate
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then p=$'\e[38;5;213m'; r=$'\e[0m'; else p=''; r=''; fi
printf '\n%s   /\\_/\\   ___\n  ( o.o ) |   |   <- the cup is back on the table.\n   > ^ <  |___|%s\n' "$p" "$r"
echo "Copycat is clean.  ssh copycat@127.0.0.1 -p 2222   (password: copycat)"
