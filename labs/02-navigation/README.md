# Lab 02 — Navigation  (about 10 min)

**Goal:** move around the filesystem and read what you see.

**Start here:** `cd ~`

## Steps

1. Go somewhere, come back:
   ```
   cd ~/Documents
   pwd
   cd ..
   pwd
   cd -
   pwd
   ```
   `..` is the parent folder. `cd -` jumps back to where you just were.
2. Listings with more detail each time:
   ```
   ls
   ls -l
   ls -la
   ls -lh ~/test-data
   ```
   `-l` long format, `-a` includes hidden (dot) files, `-h` human-readable sizes.
3. A picture of a folder:
   ```
   tree ~/Projects
   tree -L 1 ~
   ```
4. The trailing slash on a glob:
   ```
   ls -d ~/test-data/*
   ls -d ~/test-data/*/
   ```
   The second prints an error: `test-data` holds files but no folders.
5. Sort a listing:
   ```
   ls -lS ~/test-data
   ls -lt ~
   ```
6. Two shortcuts:
   ```
   cd
   cd /
   ls
   ```
   A bare `cd` always takes you home. `/` is the top of the filesystem.

## Check yourself
- Which file in `~/test-data` is the biggest, and how many bytes is it?
- What does `ls -la ~` show that `ls ~` does not?
- What is the difference between `/home/copycat` and `~`?

## Challenge
Without using `cd`, list the contents of `~/labs/04-search/haystack/beta/two` with one `ls`
command, then show it with `tree`.

## Done
```
copycat-done 02
```

Broke something? Run `copycat-reset` on your PC (not in here).
