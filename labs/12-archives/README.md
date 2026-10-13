# Lab 12 — Archives and compression  (about 15 min)

**Goal:** bundle folders into one file, compress them, and unpack them again.

**Start here:** `cd ~/labs/12-archives`

`tar` bundles, `gzip` compresses; `tar -z` does both. `zip` does both in one format that
Windows also understands.

## Steps

1. Look at what you will pack:
   ```
   ls -l to-compress
   du -sh to-compress
   ```
2. tar + gzip:
   ```
   tar -czf data.tar.gz to-compress
   ls -lh data.tar.gz
   tar -tzf data.tar.gz
   ```
   Flags: `c` create, `z` gzip, `f` file name. `t` lists contents without unpacking.
3. Unpack somewhere safe:
   ```
   mkdir out
   tar -xzf data.tar.gz -C out
   ls out/to-compress
   ```
   `x` is extract, `-C` picks the target folder.
4. zip:
   ```
   zip -r data.zip to-compress
   unzip -l data.zip
   ```
5. Compress a single file and keep the original:
   ```
   gzip -k to-compress/data1.txt
   ls -l to-compress
   gunzip -c to-compress/data1.txt.gz | head -3
   ```
6. Clean up:
   ```
   rm -r out data.tar.gz data.zip to-compress/data1.txt.gz
   ```

## Check yourself
- How big is `to-compress`, and how big is `data.tar.gz`? Why such a difference?
- What does `tar -xzf data.tar.gz` do if you forget `-C`?
- What is the difference between `gzip file` and `gzip -k file`?

## Challenge
Create a `.tar.bz2` of `to-compress` (hint: swap `z` for `j`) and compare its size with the
`.tar.gz`.

## Done
```
copycat-done 12
```

Broke something? Run `copycat-reset` on your PC (not in here).
