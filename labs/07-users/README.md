# Lab 07 — Users and groups  (about 15 min)

**Goal:** see who exists, create a user and a group, and switch identity.

**Start here:** `cd ~`

Typing a password prints nothing at all. That is normal.

## Steps

1. Who exists:
   ```
   id alex
   groups jordan
   tail -5 /etc/passwd
   getent group | grep -E 'students|developers|admins'
   ```
   `/etc/passwd` lists accounts, `/etc/group` lists groups.
2. Become root for one command:
   ```
   whoami
   sudo whoami
   sudo -l
   ```
   `sudo` asks for YOUR password (`copycat`), not root's.
3. Make a user (it will ask you to choose a password):
   ```
   sudo useradd -m -s /bin/bash testuser
   sudo passwd testuser
   id testuser
   ```
   `-m` creates a home folder.
4. Be that user:
   ```
   su - testuser
   whoami
   pwd
   exit
   ```
5. Groups:
   ```
   sudo groupadd labrats
   sudo usermod -aG labrats,developers testuser
   id testuser
   ```
   `-aG` means append to groups. Without `-a` you would REPLACE the user's groups.
6. Clean up:
   ```
   sudo userdel -r testuser
   sudo groupdel labrats
   ```

## Check yourself
- Which command shows only the groups of the current user?
- What UID does `root` have? What is the first normal user's UID (`id copycat`)?
- Why can `copycat` use `sudo` but `alex` cannot? (Hint: `groups copycat`.)

## Challenge
Create a user `guest`, add it to `students`, check that `ls -ld /home/guest` shows it as
the owner, then remove the user and its home folder.

## Done
```
copycat-done 07
```

Broke something? Run `copycat-reset` on your PC (not in here).
