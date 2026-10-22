# Lab 24 — Advanced file permissions  (about 35 min, graded)

**Question:** what are umask, ACLs, SUID, SGID and the sticky bit?

## Concepts
- **umask** removes permission bits from newly created files. `umask 022` means new files are `644` and new directories `755`.
- **setgid on a directory** (`g+s`, shown as `s` in the group triplet): new files inherit the directory's group, so a team shares files cleanly.
- **sticky bit** on a directory (`+t`, shown as `T`/`t` at the end): users can delete only their own files there (like `/tmp`).
- **setuid** (`u+s`) on a program makes it run as the file's owner. Powerful and dangerous: legitimate on `passwd`, a red flag anywhere else.
- **ACL**: permissions for a specific extra user or group beyond owner/group/other (`setfacl`, `getfacl`).

## Warm-up
```
umask
umask 077; touch /tmp/u1; mkdir /tmp/ud; ls -ld /tmp/u1 /tmp/ud; umask 022
ls -ld /tmp                       # the t at the end
find /usr/bin -perm -4000 2>/dev/null | head     # setuid programs
```

## Graded challenge
```
copycat-setup 24
```
Copycat builds a small team area under `/srv/lab24`. Fix it (use `sudo`, password `copycat`) so that:
1. `/srv/lab24/shared` belongs to the group `developers`, is setgid **and** sticky, and "other" has no access (mode `3770`).
2. `sam` (who is not in `developers`) can **read but not write** `/srv/lab24/shared/handbook.txt`, using ACLs: `r` on the file, and `x` (search) on the `shared` folder so `sam` can reach it. "Other" has no access to the file.
3. The helper `/srv/lab24/tools/report` must no longer be setuid or setgid.

Investigate with `ls -ld`, `stat`, `getfacl`, `find /srv/lab24 -perm /6000`. Then:
```
copycat-check 24
```

## Check yourself
- Why does an ACL entry for `sam` not need `sam` to join the group?
- What does the `mask` line in `getfacl` do?
- Why is setuid on a shell script a bad idea?

## Done
Score 100 in `copycat-check 24`, or `copycat-done 24`.
