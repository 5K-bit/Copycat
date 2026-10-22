#!/bin/bash
# Root-side runner for troubleshooting scenarios. The student may run only `break` and `reset`
# through sudo (see /etc/sudoers.d/copycat-trouble). `fix` exists for the self-test and is not
# sudo-able by the student; run it as root.
#   trouble-run.sh break|reset|fix <scenario>
action=$1 name=$2
dir=/usr/local/lib/copycat/scenarios
case $action in break|reset|fix) ;; *) echo "usage: trouble-run.sh break|reset|fix <scenario>"; exit 2 ;; esac
case $name in ''|*[!a-z-]*) echo "bad scenario name"; exit 2 ;; esac
[ -f "$dir/$name.sh" ] || { echo "no such scenario: $name"; exit 2; }
# shellcheck disable=SC1090
. "$dir/$name.sh"
"s_$action"
