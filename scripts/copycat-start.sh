#!/usr/bin/env bash
cd "$(dirname "$0")/.." && docker compose up -d --build
echo; echo "Connect:  ssh copycat@127.0.0.1 -p 2222   (password: copycat)"
