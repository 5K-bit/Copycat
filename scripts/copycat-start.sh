#!/usr/bin/env bash
cd "$(dirname "$0")/.." || exit 1
. scripts/ui.sh
ui_banner
ui_run "Building and starting Copycat" docker compose up -d --build || exit $?
echo; ui_info "Connect:  ssh copycat@127.0.0.1 -p 2222   (password: copycat)"
