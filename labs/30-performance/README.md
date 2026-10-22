# Lab 30 — System performance  (about 25 min)

**Question:** what is consuming CPU, memory, storage or other resources?

Method: look at the whole machine first (CPU, memory, disk, load), then find the process behind the number.

## Steps
1. The overview:
   ```
   uptime                  # load averages for 1, 5, 15 minutes
   nproc                   # number of CPUs: load above this means queueing
   free -h                 # memory: look at "available", not "free"
   df -h                   # storage
   vmstat 1 5              # CPU, memory, swap, I/O per second
   ```
2. Who is responsible:
   ```
   ps aux --sort=-pcpu | head -5     # top CPU users
   ps aux --sort=-rss  | head -5     # top memory users
   top -b -n1 | head -15
   ```
3. Create a load on purpose, find it, and stop it:
   ```
   yes > /dev/null &                 # burns one CPU core
   ps aux --sort=-pcpu | head -3
   kill %1
   ```
4. Disk and files:
   ```
   du -sh /var/log/* 2>/dev/null | sort -rh | head -5
   lsof 2>/dev/null | wc -l          # open files
   ```
5. Practise with a real mystery: Copycat starts an unknown process, you find it:
   ```
   copycat-trouble start cpu-overload
   copycat-trouble check             # after you stopped the right process
   ```

## Check yourself
- A load average of 4 on a 2-CPU machine means what?
- Why is "free memory" near zero on a healthy Linux system?
- How do you tell "busy" from "waiting for disk" in `vmstat`?

## Challenge
Write a one-line command that prints the PID, user and command of the single process using the most memory.

## Done
```
copycat-done 30
```
