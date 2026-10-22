# Lab 31 — User administration  (about 30 min, graded)

**Challenge:** create users, assign groups, and enforce an access policy.

## Concepts
- Users live in `/etc/passwd`, password hashes in `/etc/shadow` (root-only), groups in `/etc/group`.
- Tools: `useradd`, `usermod`, `userdel`, `groupadd`, `passwd`, `chage` (password aging), `id`, `getent`.
- A **primary group** is the one files are created with; **supplementary groups** add more access.

## Warm-up
```
id; id alex
getent passwd alex
getent group developers
sudo -l | head -5
```

## Graded challenge
```
copycat-setup 31
```
A new intern, **taylor**, starts today. As copycat (use `sudo`, password `copycat`) make this true:
1. User `taylor` exists with a home directory `/home/taylor` and the shell `/bin/bash`.
2. `taylor` is in the groups `students` and a **new** group `interns`, and is **not** in `sudo`.
3. A shared folder `/srv/interns` exists, owned by group `interns`, with mode `2770` (group members only, new files inherit the group).
4. `taylor`'s password must be changed at least every 90 days (`chage -M 90 taylor`).
5. `sam` is **not** added to `interns` (give access only to who needs it).

Useful: `man useradd`, `sudo useradd -m -s /bin/bash -G students taylor`, `sudo groupadd interns`, `sudo usermod -aG interns taylor`, `sudo chage -l taylor`.

When done:
```
copycat-check 31
```

## Check yourself
- What is the difference between `usermod -G x` and `usermod -aG x`? What goes wrong with the first?
- Why does the `2` in `2770` matter for a shared folder?
- Where would you look to see whether an account has a password at all?

## Done
Score 100 in `copycat-check 31`, or `copycat-done 31`.
