#!/bin/bash
# Start real services, leave a few harmless long-running processes to inspect/kill,
# then stay in the foreground tailing the auth log (visible via `docker logs`).
set -e

touch /var/log/auth.log /var/log/syslog
# newer rsyslog packages ship no /etc/init.d script, so start the daemon directly
if [ -x /etc/init.d/rsyslog ]; then service rsyslog start; else rsyslogd; fi
service cron start
service ssh start

runuser -u copycat -- bash -c '
  cd ~
  setsid nohup ~/scripts/busywork.sh   >/dev/null 2>&1 &
  setsid nohup ~/scripts/slow-counter.sh >/dev/null 2>&1 &
  setsid nohup sleep 100000            >/dev/null 2>&1 &
'

echo "copycat-kali ready: ssh copycat@127.0.0.1 -p 2222"
exec tail -n 20 -F /var/log/auth.log
