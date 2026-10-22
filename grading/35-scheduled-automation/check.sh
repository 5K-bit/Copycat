#!/bin/bash
. /usr/local/lib/copycat/grade.sh
d="$HOME/labs/35-scheduled-automation"
s="$d/heartbeat.sh"
log="$d/heartbeat.log"

grade_start 35 "SCHEDULED AUTOMATION"

grade_section "Script"
item "heartbeat.sh must exist (copycat-setup 35 first)" test -f "$s"
item "heartbeat.sh must be executable" test -x "$s"
item "heartbeat.sh must start with a shebang (#!/bin/bash)" bash -c "head -1 '$s' | grep -q '^#!'"
item "heartbeat.sh must write to an absolute log path (cron's working folder is not this one)" grep -q "^[^#]*/home/copycat/labs/35-scheduled-automation/heartbeat.log" "$s"

grade_section "Schedule"
item "your crontab must call heartbeat.sh by its absolute path" bash -c "crontab -l 2>/dev/null | grep -v '^[[:space:]]*#' | grep -q '/home/copycat/labs/35-scheduled-automation/heartbeat.sh'"
item "it must run every minute (* * * * *)" bash -c "crontab -l 2>/dev/null | grep -v '^[[:space:]]*#' | grep 'heartbeat.sh' | grep -Eq '^[[:space:]]*(\\*|\\*/1)[[:space:]]+\\*[[:space:]]+\\*[[:space:]]+\\*[[:space:]]+\\*[[:space:]]'"
item "the cron service must be running" service cron status

grade_section "Cron actually ran it"
item "heartbeat.log needs at least 2 lines (wait a couple of minutes)" test "$(wc -l < "$log" 2>/dev/null || echo 0)" -ge 2
item "log lines must look like 'YYYY-MM-DD_HH:MM:SS beat'" bash -c "tail -1 '$log' | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9:]{8} beat\$'"

grade_finish
