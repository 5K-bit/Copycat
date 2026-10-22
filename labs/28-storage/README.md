# Lab 28 — Storage: filesystems, partitions, mounts and swap  (about 30 min)

**Question:** how do filesystems, partitions, mounts and swap work?

Copycat cannot mount real disks (no privileges, on purpose), so you learn the commands by *reading* the
system and by building a filesystem inside an ordinary file.

## Concepts
- A **disk** is split into **partitions**; each holds a **filesystem** (ext4, xfs...) that gives it files and folders.
- A filesystem becomes usable when **mounted** at a folder (a mount point).
- **/etc/fstab** lists what to mount at boot. **Swap** is disk space used as overflow memory.

## Steps
1. What is mounted, how full, and of what type:
   ```
   df -hT | head
   findmnt | head -15
   cat /proc/mounts | head
   ```
2. What eats space:
   ```
   du -sh /var /usr /home 2>/dev/null
   du -ah ~/labs | sort -rh | head -5
   ```
3. A tiny separate "disk" is mounted at /mnt/smalldisk (8 MB):
   ```
   df -h /mnt/smalldisk
   dd if=/dev/zero of=/mnt/smalldisk/fill bs=1M count=20   # runs out of space
   df -h /mnt/smalldisk
   rm /mnt/smalldisk/fill
   ```
4. Build a real ext4 filesystem inside a file (no mount needed):
   ```
   truncate -s 16M ~/disk.img
   mkfs.ext4 -q ~/disk.img
   dumpe2fs -h ~/disk.img 2>/dev/null | grep -E 'Filesystem (UUID|volume name)|Block count|Block size'
   e2fsck -n ~/disk.img
   ```
   On a real machine you would now `sudo mount -o loop ~/disk.img /mnt`; here you only inspect it.
5. fstab and swap, read-only:
   ```
   cat /etc/fstab
   free -h
   cat /proc/swaps
   lsblk 2>/dev/null | head || echo "no block devices visible in a container"
   ```

## Check yourself
- What is the difference between a partition, a filesystem and a mount point?
- Why does a full filesystem stop even tiny writes?
- What would an `/etc/fstab` line `UUID=... /data ext4 defaults 0 2` do at boot?

## Challenge
Make a 32 MB image with a label (`mkfs.ext4 -L data`), read the label back with `dumpe2fs`, and compute how many 4 KB blocks it has.

## Done
```
copycat-done 28
```
