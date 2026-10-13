# Lab 01 — Core commands  (about 10 min)

**Goal:** find out who you are, where you are, and what this system is.

**Start here:** you are already in the right place (`~`, your home folder).

Everything is real Linux. Run each command and compare with what you expected.

## Steps

1. Who and where:
   ```
   whoami
   pwd
   hostname
   ```
   You should see `copycat`, `/home/copycat` and `copycat-kali`.
2. About the system:
   ```
   uname -a
   date
   cal
   ```
   `uname -a` names the kernel. `cal` draws this month.
3. Print text, clear the screen, read a manual:
   ```
   echo hello
   clear
   man ls
   ```
   In the manual use the arrow keys to scroll and `q` to quit.
4. Find out what a command is and where it lives:
   ```
   whatis grep
   whereis ssh
   which bash
   ```
5. Aliases are shortcuts that last until you log out:
   ```
   alias hi='echo hello'
   hi
   alias
   unalias hi
   hi
   ```
   The last `hi` should say `command not found`.

## Check yourself
- What is the difference between `which bash` and `whereis bash`?
- Run `type ll`, `type cd` and `type ls`. Which are aliases, which are built into the shell,
  and which are files on disk?
- Why does `uname -a` mention a Microsoft/WSL kernel when this is Kali?
  (Hint: containers share the host's kernel.)

## Challenge
Use `man date` to print today's weekday name only, e.g. `Friday`.

## Done
```
copycat-done 01
```

Broke something? Run `copycat-reset` on your PC (not in here).
