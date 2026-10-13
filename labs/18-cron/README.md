# Lab 18 — Scheduling with cron  (about 10 min)

**Goal:** run a command automatically on a schedule, and read cron's own log.

**Start here:** `cd ~`

The `cron` daemon is already running in this box. A **crontab** is a per-user list of lines:

```
minute  hour  day-of-month  month  day-of-week   command
  *      *        *           *        *         every minute
 */5     *        *           *        *         every 5 minutes
  30     2        *           *       1-5        02:30, Monday to Friday
```

## Steps

1. See that you have no jobs yet:
   ```
   crontab -l
   service cron status
   ```
   "no crontab for copycat" is expected.
2. Add a job that appends the time to a file every minute. (This is the non-interactive way;
   `crontab -e` would open an editor instead.)
   ```
   (crontab -l 2>/dev/null; echo '* * * * * date >> /tmp/cron-demo.log') | crontab -
   crontab -l
   ```
3. Wait about a minute, then:
   ```
   cat /tmp/cron-demo.log
   ```
   Wait another minute and `cat` again to see a second line.
4. Cron logs each run:
   ```
   sudo grep CRON /var/log/syslog | tail -5
   ```
5. A job that fails silently is a classic trap. Add one, wait a minute and look:
   ```
   (crontab -l; echo '* * * * * ls /nonexistent 2>> /tmp/cron-err.log') | crontab -
   cat /tmp/cron-err.log
   ```
6. Remove all your jobs:
   ```
   crontab -r
   crontab -l
   ```

## Check yourself
- What do the five fields `0 9 * * 1` mean in words?
- Why do cron jobs usually use full paths like `/usr/bin/date`?
- Where does a cron job's output go if you do not redirect it?

## Challenge
Write a crontab line that runs `~/scripts/hello.sh` at minute 0 of every hour and appends the
output to `/tmp/hello.log`. Do not install it; just write the line.

## Done
```
copycat-done 18
```

Broke something? Run `copycat-reset` on your PC (not in here).
