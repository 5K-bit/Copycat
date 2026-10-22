# Lab 35 — Scheduled automation with cron  (about 30 min, graded)

**Challenge:** create an automated task and troubleshoot why it does not run.

## Concepts
- `cron` runs commands on a schedule. Edit your table with `crontab -e`, list it with `crontab -l`.
- A line has five time fields then the command: `minute hour day-of-month month day-of-week command`.
  `* * * * *` = every minute, `*/5 * * * *` = every 5 minutes, `30 2 * * *` = 02:30 daily.
- cron runs with a **tiny environment** (short `PATH`, no login shell): use absolute paths and redirect output to a log.
- Cron is a real service here: `service cron status`.

## Warm-up
```
service cron status
crontab -l 2>&1 | head
```

## Graded challenge
```
copycat-setup 35
cd ~/labs/35-scheduled-automation
cat heartbeat.sh; ls -l heartbeat.sh
```
`heartbeat.sh` should append a timestamped line to `heartbeat.log` in this folder, but it does not work yet.
1. Make `heartbeat.sh` correct and executable: it needs a shebang (`#!/bin/bash`) and must write a line such as `2026-10-22_09:00:01 beat` using absolute paths.
2. Run it once by hand to confirm.
3. Schedule it **every minute** with `crontab -e`, using the absolute path to the script.
4. Wait about two minutes, then look at `heartbeat.log`: cron itself must have added lines (at least 2 in total).
   If nothing appears: is the script executable? Does the crontab line have 5 time fields? `grep CRON /var/log/syslog` may show errors.

Then:
```
copycat-check 35
```

## Check yourself
- Why must the crontab line use `/home/copycat/...` rather than `~/...` or a relative path?
- What does `>> file 2>&1` at the end of a cron command do?
- How would you run a job at 02:30 on weekdays only?

## Done
Score 100 in `copycat-check 35`, or `copycat-done 35`.
