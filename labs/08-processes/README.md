# Lab 08 — Processes  (about 15 min)

**Goal:** see what is running, run things in the background, and stop them.

**Start here:** `cd ~`

Three harmless jobs started when the lab booted: `busywork.sh`, `slow-counter.sh` and a
`sleep 100000`.

## Steps

1. Look:
   ```
   ps aux | grep -E 'busywork|slow-counter|sleep' | grep -v grep
   pgrep -a sleep
   ```
   The second column of `ps aux` is the PID.
2. A live view (press `q` to leave):
   ```
   top
   ```
3. Background and foreground jobs:
   ```
   sleep 300 &
   jobs
   fg
   ```
   `fg` brings it forward; press `Ctrl+Z` to suspend it, then:
   ```
   bg
   jobs
   kill %1
   jobs
   ```
   `Ctrl+C` would stop it for good. `Ctrl+Z` only pauses it.
4. Stop by PID or by name:
   ```
   pgrep -a slow-counter
   kill <PID from the line above>
   pkill -f busywork
   ps aux | grep -E 'busywork|slow-counter' | grep -v grep
   ```
   Both scripts should be gone from the list.
5. Survive logout:
   ```
   nohup sleep 500 &
   ```

## Check yourself
- What is the difference between `kill` and `kill -9`?
- What does the `&` at the end of a command do?
- Who started `sleep 100000`, and what is its PPID? (`ps -o pid,ppid,user,cmd -p $(pgrep -f 'sleep 100000')`)

## Challenge
Start `sleep 1000` three times, then kill all three with one command.

## Done
Note: killed jobs stay dead until `copycat-reset`. That is fine.
```
copycat-done 08
```

Broke something? Run `copycat-reset` on your PC (not in here).
