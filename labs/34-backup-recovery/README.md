# Lab 34 — Backup and recovery  (about 30 min, graded)

**Challenge:** restore an accidentally deleted configuration file, then make a verified backup.

## Concepts
- A backup you have not **tested** is a hope, not a backup. Always check an archive (`tar -tzf`, `gzip -t`) and try a restore.
- Tools: `tar` (bundle), `gzip` (compress), `rsync` (copy only changes), `cp -a` (preserve permissions and times), `sha256sum` (prove files are identical).
- The 3-2-1 rule: 3 copies, 2 kinds of media, 1 off-site.

## Warm-up
```
mkdir -p /tmp/bk && cd /tmp/bk && echo data > f.txt
tar -czf f.tgz f.txt && tar -tzf f.tgz && gzip -t f.tgz && echo "archive OK"
rm f.txt && tar -xzf f.tgz && cat f.txt
```

## Graded challenge
```
copycat-setup 34
cd ~/labs/34-backup-recovery
ls -R
```
Someone deleted `site/settings.conf`. A backup of the whole `site` folder exists in `backup/`.
1. Find the right archive (`ls backup`, `tar -tzf`) and **restore only `settings.conf`** to `site/` (do not overwrite the other files).
2. Confirm the restored file's content contains `max_users=250`.
3. Make a **new** verified backup of the repaired site as `backup/site-restored.tar.gz` that contains the `site` folder, and test it with `tar -tzf` and `gzip -t`.

Then:
```
copycat-check 34
```

## Check yourself
- Why restore one file rather than extract everything over the live folder?
- What does `tar -tzf` prove, and what does it not prove?
- How would you schedule this backup every night? (See lab 35.)

## Done
Score 100 in `copycat-check 34`, or `copycat-done 34`.
