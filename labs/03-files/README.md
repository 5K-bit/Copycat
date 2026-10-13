# Lab 03 — Files  (about 15 min)

**Goal:** create, copy, move, link, read and delete files, and learn that delete is forever.

**Start here:** `cd ~`

There is no trash can. `rm` deletes immediately and without asking. Stay inside the
`sandbox-03` folder you create below.

## Steps

1. Make a workspace:
   ```
   mkdir sandbox-03
   cd sandbox-03
   touch a.txt
   ls -l
   ```
   `touch` creates an empty file (size 0).
2. Put text in it, copy it, rename it:
   ```
   echo "hello copycat" > a.txt
   cp a.txt b.txt
   mv b.txt c.txt
   ls
   cat c.txt
   ```
   `mv` is both "move" and "rename".
3. Make a symbolic link:
   ```
   ln -s ~/test-data/numbers.txt link.txt
   ls -l link.txt
   cat link.txt
   ```
   The `->` in `ls -l` shows what the link points to.
4. Read files in different ways:
   ```
   cat ~/test-data/numbers.txt
   head -3 ~/test-data/large-file.txt
   tail -3 ~/test-data/large-file.txt
   wc -l ~/test-data/large-file.txt
   less ~/test-data/large-file.txt
   ```
   In `less`: arrow keys scroll, `/fox` searches, `q` quits. `wc -l` should say 5000.
5. Delete things:
   ```
   rm a.txt
   cd ..
   rm -r sandbox-03
   ls
   ```
   `rm -r` removes a folder and everything inside it.

## Check yourself
- After step 3, what happens to `link.txt` if you `rm link.txt`? Is `numbers.txt` still there?
- What does `mkdir -p a/b/c` do that plain `mkdir a/b/c` does not?
- What is the difference between `cp -r` and `cp`?

## Challenge
In a new folder, copy `~/test-data/employees.csv` under a different name and, using only
`head` and `tail`, show just line 4 of it.

## Done
```
copycat-done 03
```

Broke something? Run `copycat-reset` on your PC (not in here).
