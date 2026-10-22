# Lab 25 — The Linux boot process  (about 25 min)

**Question:** what happens between power-on and the login prompt?

Copycat runs in a container, so it never really boots: there is no firmware or kernel loading here. This
lab teaches the real sequence and lets you inspect what a container shows of it.

## The sequence on a real machine
1. **Firmware** (UEFI/BIOS) tests the hardware and finds a boot device.
2. **Bootloader** (GRUB) loads the kernel and an initial RAM disk.
3. **Kernel** starts, detects hardware, mounts the root filesystem.
4. **init (PID 1)** — usually systemd — starts everything else: services, networking, the login prompt.
5. A **login** process (getty/sshd) lets you in and starts your shell.

## Steps
1. See the top of the process tree. In a container PID 1 is a tiny init, not a full boot:
   ```
   ps -p 1 -o pid,comm,args
   pstree -p | head -15
   ```
2. See which services this "boot" started and how (init scripts, no systemd):
   ```
   ls /etc/init.d
   cat /entrypoint.sh
   ```
3. Kernel facts. The kernel is shared with the host machine:
   ```
   uname -r
   cat /proc/version
   cat /proc/cmdline 2>/dev/null || echo "no kernel command line visible"
   ```
4. Read the manual for the real thing:
   ```
   man 7 boot | head -60
   man 7 bootup | head -60
   ```
5. Services start at boot only if they are enabled for it. See the idea with cron:
   ```
   ls /etc/rc2.d | head
   ```

## Check yourself
- Which step loads the kernel, and which step starts your services?
- Why does this container have no GRUB and no kernel messages (`dmesg`)?
- What is PID 1 responsible for, and what happens to the system if it exits?

## Challenge
Write the five boot stages from memory, then match each to one command or file that shows evidence of it
on a real Linux machine (for example `journalctl -b`, `/boot/grub/grub.cfg`, `systemd-analyze`).

## Done
```
copycat-done 25
```
