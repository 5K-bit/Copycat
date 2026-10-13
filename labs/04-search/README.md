# Lab 04 — Searching  (about 15 min)

**Goal:** find files by name, type and size, and find text inside files.

**Start here:** `cd ~/labs/04-search`

This folder has a `haystack/` of nested folders with one hidden `needle.txt`.

## Steps

1. Find files by name:
   ```
   find ~ -name '*.txt' | head
   find ~/test-data -name 'n*'
   ```
   Quote the pattern so the shell does not expand it first.
2. Find by type and size:
   ```
   find haystack -type d | head
   find haystack -type f -size +1k
   find haystack -empty
   ```
3. Use the file database (instant, but only as fresh as the last `updatedb`):
   ```
   locate numbers.txt
   ```
4. Find text inside files:
   ```
   grep -R NEEDLE haystack
   grep -R ERROR ~/logs | head -3
   grep -rn "fox" ~/test-data/large-file.txt | head -2
   ```
   `-R` recurses, `-n` shows line numbers.
5. Refine:
   ```
   grep -c ERROR ~/logs/error.log
   grep -i "disk usage" ~/logs/error.log | head -2
   grep -v ERROR ~/logs/error.log | head -3
   ```
   `-c` counts, `-i` ignores case, `-v` inverts (lines that do NOT match).

## Check yourself
- How many `note.txt` files are in `haystack`? (Hint: `find ... | wc -l`. It is 18.)
- Which file in `haystack` is bigger than 1 KB?
- What does `locate` miss that `find` does not?

## Challenge
Create a new file `~/labs/04-search/haystack/alpha/one/y/fresh.txt`, then show that `locate
fresh.txt` does not find it but `find` does. What would make `locate` find it? (Hint: `sudo updatedb`.)

## Done
```
copycat-done 04
```

Broke something? Run `copycat-reset` on your PC (not in here).
