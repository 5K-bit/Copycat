# Lab 39 — Linux hardening  (about 35 min, graded)

**Challenge:** find insecure settings on a server and correct them.

## Hardening checklist (the usual suspects)
- **World-writable files** (`o+w`): anyone can change them. Find with `find / -xdev -type f -perm -0002`.
- **Setuid/setgid programs** that should not be: `find / -xdev -perm /6000`. Each one is a possible path to root.
- **Secrets readable by everyone** (passwords, keys, tokens): should be `600` and owned by the account that needs them.
- **Accounts with empty or unlocked passwords**: `sudo passwd -S USER` shows `L` (locked), `P` (has a password) or `NP` (no password!).
- **Least privilege**: remove what is not needed; never fix a permission problem with `chmod 777`.

## Warm-up
```
find /tmp /srv -xdev -type f -perm -0002 2>/dev/null | head
find /usr/bin -perm /4000 2>/dev/null | head
passwd -S copycat 2>/dev/null; getent shadow >/dev/null 2>&1 || echo "(shadow is root-only: use sudo)"
```

## Graded challenge
```
copycat-setup 39
find /srv/hardening -ls
```
A server under `/srv/hardening` has been set up carelessly. Audit it and correct **all** of these (use `sudo`, password `copycat`):
1. `app.conf` is world-writable. Nobody except its owner may write it (owner and group may read it).
2. `viewer` is a program with the **setuid** bit. Remove the special bit (keep it executable by everyone).
3. `db-password.txt` is readable by everybody. Only its owner may read or write it.
4. The account `guest` has **no password at all**. Lock it (`passwd -l guest`).
5. Do not "fix" things by deleting files: all three files must still exist with their content.

Then:
```
copycat-check 39
```

## Check yourself
- Why is a world-writable config file worse than a world-readable one?
- Why do setuid programs deserve a periodic audit?
- What is the difference between locking an account and deleting it?

## Done
Score 100 in `copycat-check 39`, or `copycat-done 39`.
