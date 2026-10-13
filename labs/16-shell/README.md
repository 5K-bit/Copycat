# Lab 16 — Shell and shortcuts  (about 10 min)

**Goal:** work faster at the prompt, and understand variables and `PATH`.

**Start here:** `cd ~`

## Steps

1. Editing the command line. Type `echo one two three` but do NOT press Enter, then try:
   - `Ctrl+A` start of line, `Ctrl+E` end of line
   - `Ctrl+W` delete the word before the cursor, `Ctrl+U` delete to the start, `Ctrl+K` to the end
   - `Ctrl+L` clear the screen, `Ctrl+C` abandon the line
2. Search your past commands:
   ```
   history | tail
   ```
   Then press `Ctrl+R` and start typing part of an old command. Enter runs it, `Esc` edits it.
3. Repeat things:
   ```
   echo hi
   !!
   history | tail -3
   ```
   `!!` re-runs the last command. `!N` re-runs history entry number N.
4. Tab completion: type `cd ~/te` and press `Tab`. Press `Tab` twice on an ambiguous prefix to
   list the options.
5. Variables:
   ```
   export GREETING=hi
   echo $GREETING
   env | grep GREETING
   bash -c 'echo $GREETING'
   ```
   `export` makes the variable visible to programs you start (the last line proves it).
6. Where do commands come from?
   ```
   echo $PATH
   type ls
   ~/scripts/hello.sh
   ```
   The shell searches the `PATH` folders in order. `hello.sh` is not on it, so you must give
   its full path.
7. Exit status. Run `ls /nonexistent` and look at the cat in your prompt:
   ```
   ls /nonexistent
   echo $?
   ls ~
   echo $?
   ```
   `=^x^=` (red) after a failure, `=^.^=` (green) after success. `$?` is 0 for success.

## Check yourself
- What happens if you `export` a variable in one session and then log in again?
- What is the difference between `cat ~/.bashrc` and `source ~/.bashrc`?
- Why does `./hello.sh` work but `hello.sh` does not?

## Challenge
Add `~/scripts` to your `PATH` for this session, then run `hello.sh` with no path.

## Done
```
copycat-done 16
```

Broke something? Run `copycat-reset` on your PC (not in here).
