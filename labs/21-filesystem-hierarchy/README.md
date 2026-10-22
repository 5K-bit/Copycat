# Lab 21 — The Linux filesystem hierarchy  (about 20 min)

**Question:** what are `/etc`, `/var`, `/usr`, `/proc` and `/dev` used for?

**Start here:** `cd /`

Linux puts everything in one tree. Where a file lives tells you what it is.

## Steps
1. Look at the top level and what each folder is documented to hold:
   ```
   ls /
   man hier | head -60
   ```
2. Match each folder to its job by looking inside:
   ```
   ls /etc | head          # configuration (text files you can read)
   ls /var/log             # logs and other data that changes while running
   ls /usr/bin | head      # installed programs
   ls /home                # users' own files
   ls /tmp                 # scratch space, cleared at reboot
   ```
3. Two folders that are not on disk at all; the kernel makes them up live:
   ```
   cat /proc/cpuinfo | head -5     # information about the CPU
   cat /proc/1/cmdline | tr '\0' ' '; echo   # the command line of process 1
   ls /dev | head                  # devices as files
   echo hello > /dev/null          # /dev/null swallows anything
   head -c 8 /dev/urandom | od -An -tx1
   ```
4. Find where a command really lives, and which config belongs to a program:
   ```
   which ls
   type cd
   ls /etc/ssh
   ```

## Check yourself
- Where would you look for the SSH server's configuration? For its log?
- Why can you `cat /proc/cpuinfo` although no file is stored on any disk?
- What is the difference between `/bin`, `/usr/bin` and `/usr/local/bin`?

## Challenge
Without opening the files, list three directories that hold *configuration*, *logs* and *user data*, then prove each with `ls`.

## Done
```
copycat-done 21
```
