# Lab 38 — Bash automation  (about 40 min, graded)

**Challenge:** write a script with conditions, loops, functions and error handling.

## Building blocks
```bash
#!/bin/bash
set -u                                   # error on unset variables
usage() { echo "usage: $0 FILE..." >&2; exit 2; }     # a function
[ $# -ge 1 ] || usage                    # a condition on the argument count
for f in "$@"; do                        # a loop over all arguments
  if [ ! -r "$f" ]; then                 # error handling
    echo "cannot read $f" >&2; rc=1; continue
  fi
  n=$(grep -c ERROR "$f")                # command substitution
  echo "$f has $n errors"
done
exit "${rc:-0}"                          # exit status tells callers what happened
```
Exit codes: `0` = success, non-zero = failure. Always send errors to **stderr** (`>&2`).

## Graded challenge
```
copycat-setup 38
cd ~/labs/38-bash-automation
cat logs/app1.log
```
Write `logsummary.sh` in that folder so that:
1. With **no arguments** it prints a line starting with `usage` to stderr and exits with status **2**.
2. For each file argument it prints one line: `PATH: ERROR=<n> WARN=<m>` where n and m count lines containing the words `ERROR` and `WARN`.
3. If a file is missing or unreadable, it prints a message to stderr, **keeps going** with the other files, and exits with status **1** at the end.
4. If all files are fine it exits with status **0**.
5. It uses at least one function and one loop.

Example: `./logsummary.sh logs/app1.log` -> `logs/app1.log: ERROR=3 WARN=2`

Then:
```
copycat-check 38
```

## Check yourself
- What would `set -e` change here, and why is it not always wanted?
- Why quote `"$@"` and `"$f"`?
- How do you find out if a script passes `shellcheck`?

## Done
Score 100 in `copycat-check 38`, or `copycat-done 38`.
