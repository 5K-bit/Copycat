# Lab 06 — Permissions  (about 20 min)

**Goal:** read `ls -l` permission strings, change them with `chmod`/`chown`, and see them enforced.

**Start here:** `cd ~/labs/06-permissions`

Reading `-rw-r--r-- 1 copycat copycat ...`: the first character is the type, then three
triplets for owner, group and everyone else (`r` read, `w` write, `x` execute).
Numbers: r=4, w=2, x=1, so `6` is `rw-`, `5` is `r-x`, `7` is `rwx`.

## Steps

1. Look first:
   ```
   ls -l
   id
   ```
2. Predict, then run. Is `script.sh` executable?
   ```
   ./script.sh
   chmod 755 script.sh
   ./script.sh
   ```
   The first run says `Permission denied`; the second prints `it ran`.
3. Lock yourself out of your own file:
   ```
   chmod 600 secret.txt
   cat secret.txt
   chmod 000 secret.txt
   cat secret.txt
   chmod 600 secret.txt
   ```
   The `cat` after `000` is denied, even though you own the file. The last line puts it back.
4. A file you are not allowed to read:
   ```
   ls -l admin-only.txt
   cat admin-only.txt
   sudo cat admin-only.txt
   ```
   It belongs to `root:admins` with mode 640 and you are not in `admins`, so the plain `cat`
   fails and `sudo` works.
5. Someone else's file:
   ```
   ls -l project.txt
   echo "my edit" >> project.txt
   sudo chown copycat:copycat project.txt
   echo "my edit" >> project.txt
   ```
   The first append is denied because `alex` owns it; after `chown` it works.
6. The `s` in a folder's permissions:
   ```
   ls -ld shared
   touch shared/new.txt
   ls -l shared/new.txt
   ```
   `rwxrwsr-x` has the setgid bit, so files created inside inherit the folder's group
   (`students`) instead of your own.

## Check yourself
- What does `chmod 640 file` mean, in words?
- What number is `rwxr-x---`?
- Why can `sudo cat admin-only.txt` read a file that has no permissions for you?

## Challenge
Make a new file readable and writable by you only (`rw-------`) using the numeric form, then
again using symbolic form (`chmod u=rw,go=`).

## Graded challenge: repair a locked file
Copycat breaks a file on purpose, you investigate and fix it, then it checks your work.
```
copycat-setup 06
cat ~/labs/06-permissions/challenge/report.txt     # denied. why?
ls -l ~/labs/06-permissions/challenge; id; groups; stat ~/labs/06-permissions/challenge/report.txt
```
The brief printed by `copycat-setup` lists the target state. Fix it (you will need `sudo`,
password `copycat`), then grade it:
```
copycat-check 06
```
You get a PASS/FAIL line per area and a score out of 100. Results are saved, and
`copycat-labs` shows your best score. Run `copycat-setup 06` again to break it afresh.

## Done
Finish the graded challenge (score 100), or mark the lab yourself:
```
copycat-done 06
```

Broke something? Run `copycat-reset` on your PC (not in here).
