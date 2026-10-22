# Lab 22 — Environment variables and $PATH  (about 20 min)

**Question:** how does Linux find the programs you type?

## Steps
1. See your environment and the one that matters most:
   ```
   env | sort | head -20
   echo "$PATH"
   echo "$PATH" | tr ':' '\n'
   ```
   When you type `ls`, the shell tries each folder in `PATH`, left to right, and runs the first match.
2. Watch it search:
   ```
   which -a ls
   type ls
   command -v nosuchtool || echo "not found anywhere in PATH"
   ```
3. Make your own command:
   ```
   mkdir -p ~/bin
   printf '#!/bin/bash\necho hello from my own command\n' > ~/bin/hi
   chmod +x ~/bin/hi
   hi                     # not found yet: ~/bin is not in PATH
   export PATH="$HOME/bin:$PATH"
   hi
   ```
4. Variables you set are private to the shell unless exported:
   ```
   MYVAR=abc
   bash -c 'echo "child sees: $MYVAR"'     # empty
   export MYVAR
   bash -c 'echo "child sees: $MYVAR"'     # abc
   ```
5. Make it permanent: add the `export PATH=...` line to `~/.bashrc`, then open a new shell.

## Check yourself
- Why does putting `~/bin` at the *front* of PATH matter if a tool of the same name exists elsewhere?
- What is the difference between `MYVAR=abc` and `export MYVAR=abc`?
- Why is adding `.` to PATH considered unsafe?

## Challenge
Make `hi` print a different message, then shadow the real `ls` with a script of the same name in `~/bin`, show with `type ls` that yours wins, and remove it again.

## Done
```
copycat-done 22
```
