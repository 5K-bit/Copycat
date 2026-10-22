# Lab 23 — Symbolic and hard links  (about 20 min)

**Question:** how can two paths refer to the same file or data?

**Start here:** `mkdir -p ~/labs/23-links/play && cd ~/labs/23-links/play`

## Steps
1. Make a file and look at its inode (the file's real identity) and link count:
   ```
   echo "original" > a.txt
   ls -li a.txt
   stat a.txt | head -4
   ```
2. A **hard link** is a second name for the same inode:
   ```
   ln a.txt hard.txt
   ls -li a.txt hard.txt      # same inode number, link count 2
   echo "changed" >> hard.txt
   cat a.txt                  # the change shows up through both names
   ```
3. A **symbolic link** is a small file that holds a path:
   ```
   ln -s a.txt soft.txt
   ls -l soft.txt             # soft.txt -> a.txt
   cat soft.txt
   ```
4. Delete the original and compare:
   ```
   rm a.txt
   cat hard.txt               # still works: the data lives while any hard link remains
   cat soft.txt               # broken: its target name no longer exists
   ls -l soft.txt
   ```
5. What each can and cannot do:
   ```
   mkdir d; ln d d-hard       # fails: no hard links to directories
   ln -s d d-soft && ls -l d-soft
   ln -s /etc/hostname elsewhere   # soft links may point anywhere
   readlink -f soft.txt
   find . -xtype l            # list broken symlinks
   ```

## Check yourself
- Which kind of link survives deleting the original name? Why?
- Why can a symlink point at a directory but a hard link cannot?
- What does link count `3` in `ls -l` mean?

## Challenge
Create a `current` symlink pointing at `release-1`, switch it to `release-2` in one step with `ln -sfn`, and explain why deployments use this pattern.

## Done
```
copycat-done 23
```
