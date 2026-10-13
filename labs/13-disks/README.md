# Lab 13 — Disk usage  (about 10 min)

**Goal:** see how full the disk is, find what is using it, and make a file of a known size.

**Start here:** `cd ~/labs/13-disks`

`dd` writes exactly where you tell it with `of=`, so a typo can destroy data. Only ever write
to files inside `scratch/` in this lab.

## Steps

1. How full is it:
   ```
   df -h
   df -h /
   ```
   `-h` means human-readable sizes.
2. What is using it:
   ```
   du -sh ~/*
   du -h --max-depth=1 ~ | sort -h
   ```
   `du` adds up file sizes. `sort -h` sorts "1K", "2M", "3G" correctly.
3. Make a file of a known size:
   ```
   dd if=/dev/zero of=scratch/blob bs=1M count=10
   ls -lh scratch/blob
   df -h /
   ```
   `if` is the input, `bs` the block size, `count` how many blocks. `/dev/zero` produces
   endless zero bytes. You should see exactly `10M`.
4. Find big files anywhere under your home folder:
   ```
   find ~ -type f -size +1M
   ```
5. Put it back:
   ```
   rm scratch/blob
   ```
6. Block devices (this may show your host's disks, not just the container):
   ```
   lsblk
   ```

## Check yourself
- Which folder in your home is the largest?
- What would `count=100` produce? How about `bs=1K count=1`?
- `df` measures the whole filesystem and `du` adds up the files under one folder. After
  step 3, which of them grew by about 10M, and which would you use to find WHO used the space?

## Challenge
Create a 5 MB file named `five.bin` in `scratch/`, confirm its size with `stat -c %s`, then
delete it.

## Done
```
copycat-done 13
```

Broke something? Run `copycat-reset` on your PC (not in here).
