#!/bin/bash
# Lab 35: a heartbeat script that is broken (no shebang, not executable, relative path) and no cron entry.
d=/home/copycat/labs/35-scheduled-automation
rm -rf "$d"
mkdir -p "$d"
printf 'echo "$(date +%%F_%%T) beat" >> heartbeat.log\n' > "$d/heartbeat.sh"
chmod 644 "$d/heartbeat.sh"
chown -R copycat:copycat "$d"
runuser -u copycat -- crontab -r 2>/dev/null
service cron status >/dev/null 2>&1 || service cron start >/dev/null 2>&1
cat <<'EOF'
Challenge ready: ~/labs/35-scheduled-automation/heartbeat.sh is broken and not scheduled.
Fix it, schedule it every minute with crontab -e, wait two minutes, then run:  copycat-check 35
EOF
