#!/usr/bin/env bash
# Real SSH login to the sandbox (password: copycat).
# Host-key checking is off on purpose: the port is published on 127.0.0.1 only, and a rebuilt
# image regenerates its host keys, which would otherwise trip the "HOST IDENTIFICATION HAS
# CHANGED" error. Do not copy these options to a real server.
exec ssh -p 2222 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR copycat@127.0.0.1 "$@"
