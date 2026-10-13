# Lab 15 — Package management (APT)  (about 10 min)

**Goal:** search for, install, inspect and remove software with `apt` and `dpkg`.

**Start here:** `cd ~`

This container is online, so `apt` talks to the real Kali mirrors. Everything you install
disappears at `copycat-reset`.

## Steps

1. Refresh the package list, then search:
   ```
   sudo apt update
   apt search figlet
   apt show figlet
   ```
   `apt show` prints the description, version and size without installing anything.
2. Install something that is not there yet:
   ```
   which figlet
   sudo apt install -y figlet
   which figlet
   figlet copycat
   ```
   `which` finds nothing before and a path after.
3. See what it brought:
   ```
   dpkg -L figlet | head
   dpkg -s figlet | head -5
   readlink -f $(which figlet)
   dpkg -S $(readlink -f $(which figlet))
   ```
   `dpkg -L` lists a package's files. `dpkg -S` asks which package owns a file. `figlet` is a
   symlink (managed by "alternatives"), so `readlink -f` first finds the real file.
4. Look at the whole system:
   ```
   dpkg -l | head
   dpkg -l | wc -l
   dpkg -S /usr/bin/ls
   ```
   Try `dpkg -S /bin/ls` too. It finds nothing, because on modern Debian/Kali `/bin` is a
   symlink to `/usr/bin` and dpkg records the real path.
5. Remove it again:
   ```
   sudo apt remove -y figlet
   which figlet
   ```

## Check yourself
- What is the difference between `apt update` and `apt upgrade`?
- Which package owns `/usr/bin/ls`?
- What is the difference between `apt remove` and `apt purge`?

## Challenge
Find which package provides the `dig` command, using only `dpkg` (it is already installed).

## Done
```
copycat-done 15
```

Broke something? Run `copycat-reset` on your PC (not in here).
