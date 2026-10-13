# Lab 17 — Pipes and redirection  (about 15 min)

**Goal:** connect commands together and send their output (and errors) where you want.

**Start here:** `cd ~/test-data`

Every program has three streams: **0** input (stdin), **1** output (stdout), **2** errors (stderr).

## Steps

1. Send output to a file instead of the screen:
   ```
   echo first > /tmp/out.txt
   echo second >> /tmp/out.txt
   cat /tmp/out.txt
   ```
   `>` replaces the file, `>>` appends to it.
2. Feed a file in as input:
   ```
   sort < names.txt | head -3
   wc -l < large-file.txt
   ```
3. Pipe one command into the next:
   ```
   cat employees.csv | grep Engineering | wc -l
   ```
4. Errors are a separate stream:
   ```
   ls /nonexistent ~/test-data
   ls /nonexistent ~/test-data > /tmp/o.txt
   ls /nonexistent ~/test-data 2> /tmp/e.txt
   cat /tmp/e.txt
   ls /nonexistent ~/test-data 2>/dev/null
   ```
   Predict what each shows before you run it. `/dev/null` throws everything away.
5. Both streams into one place:
   ```
   ls /nonexistent ~/test-data > /tmp/all.txt 2>&1
   cat /tmp/all.txt
   ```
6. `tee` writes to a file AND passes the data on:
   ```
   sort -n numbers.txt | tee /tmp/sorted.txt | tail -2
   ```
7. Run commands conditionally:
   ```
   mkdir /tmp/demo17 && echo "made it"
   mkdir /tmp/demo17 || echo "already there"
   ls /nonexistent; echo "still runs"
   ```
   `&&` means "only if the last one worked", `||` means "only if it failed", `;` always runs.
8. Turn lines into arguments with `xargs`:
   ```
   ls *.txt | xargs wc -l
   find ~/test-data -name '*.conf' | xargs cat
   ```
9. Capture output inside a command:
   ```
   echo "today is $(date +%A)"
   ```

## Check yourself
- What is the difference between `ls > f` and `ls >> f` if `f` already exists?
- In `cmd > out.txt 2>&1`, why does the order of `2>&1` matter?
- Why can't `cat file | sort > file` be used to sort a file in place?

## Challenge
In one line, count how many different words are in `names.txt` and `users.txt` combined, and
save the number to `/tmp/count.txt`.

## Done
```
copycat-done 17
```

Broke something? Run `copycat-reset` on your PC (not in here).
