# Lab 14 — Logs  (about 15 min)

**Goal:** answer questions from log files with `grep`, `awk`, `sort` and `uniq`.

**Start here:** `cd ~/logs`

`access.log` is a web-server log (600 lines). `error.log` is an application log (300 lines).

## Steps

1. Read a line of each:
   ```
   head -2 access.log
   head -2 error.log
   ```
   In `access.log`, field 1 is the client IP, field 7 the path and field 9 the status code.
2. Count things:
   ```
   grep ' 404 ' access.log | wc -l
   grep -c ERROR error.log
   ```
3. Top talkers (the classic pipeline):
   ```
   awk '{print $1}' access.log | sort | uniq -c | sort -rn | head
   ```
   Read it left to right: extract IPs, sort, count duplicates, sort by count, top 10.
4. Status codes and pages:
   ```
   awk '{print $9}' access.log | sort | uniq -c | sort -rn
   awk '{print $7}' access.log | sort | uniq -c | sort -rn | head -5
   ```
5. Severity levels in `error.log`:
   ```
   awk '{print $3}' error.log | sort | uniq -c
   ```
6. Follow a log live. In this terminal:
   ```
   tail -f /var/log/syslog
   ```
   Press `Ctrl+C` when done. To see something appear, open a second terminal, log in to
   copycat-kali again and run `logger "hello from lab 14"`.
7. System logs (need sudo):
   ```
   sudo tail -5 /var/log/auth.log
   ```
   Every `sudo` you ran is recorded there.

## Check yourself
- Which client IP made the most requests?
- What percentage of requests were 404s? (Hint: lines in `access.log` is 600.)
- Which error message appears most often in `error.log`?

## Challenge
List every distinct path that returned a 500, sorted by how often it happened.

## Done
```
copycat-done 14
```

Broke something? Run `copycat-reset` on your PC (not in here).
