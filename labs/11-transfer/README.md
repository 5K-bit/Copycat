# Lab 11 — File transfer  (about 15 min)

**Goal:** copy files between machines with `scp`, `sftp`, `rsync` and `wget`.

**Start here:** `cd ~`

Do lab 10 first so `ssh student@copycat-target` already works (keys make this lab quieter).

## Steps

1. `scp` (secure copy, like `cp` across machines):
   ```
   scp ~/test-data/numbers.txt student@copycat-target:/home/student/
   ssh student@copycat-target ls
   ```
   The path after the colon is on the REMOTE machine.
2. Pull a file the other way:
   ```
   scp student@copycat-target:/home/student/welcome.txt /tmp/
   cat /tmp/welcome.txt
   ```
3. `sftp` is an interactive session:
   ```
   sftp student@copycat-target
   ```
   Inside it try: `ls`, `get welcome.txt /tmp/w2.txt`, `put ~/test-data/names.txt`, `bye`.
4. `rsync` only copies what changed:
   ```
   rsync -av ~/Documents/ student@copycat-target:/home/student/docs/
   rsync -av ~/Documents/ student@copycat-target:/home/student/docs/
   ```
   The second run lists no files: nothing needed copying.
5. Download over HTTP:
   ```
   wget http://copycat-target/files/employees.csv -O /tmp/emp.csv
   head -3 /tmp/emp.csv
   curl -O http://copycat-target/files/numbers.txt
   ```

## Check yourself
- What is the difference between `rsync ~/Documents` and `rsync ~/Documents/` (trailing slash)?
- Which of these tools is the only one that can resume or skip unchanged files?
- Why do `scp` and `wget` both need no extra setup here?

## Challenge
Make a new folder `~/outbox` with two files in it, send the whole folder to the target with
one `scp` command, and prove it arrived using `ssh ... ls`.

## Done
```
copycat-done 11
```

Broke something? Run `copycat-reset` on your PC (not in here).
