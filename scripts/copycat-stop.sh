#!/usr/bin/env bash
cd "$(dirname "$0")/.." || exit 1
. scripts/ui.sh
ui_run "Stopping Copycat (your changes are kept)" docker compose stop
