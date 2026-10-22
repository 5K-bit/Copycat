# Lab 40 — System recovery  (about 40 min, graded)

**Challenge:** repair a deliberately damaged application environment.

## Method
1. **Don't panic and don't guess.** Read the error exactly.
2. **Find what changed**: `ls -la`, `stat`, `file`, `readlink`, `find -newer`, logs.
3. **Fix the smallest thing** that explains the failure, then re-test.
4. **Verify** the whole path works, not just the part you touched.
5. Keep evidence; do not delete things to make errors vanish.

## Useful tools
`ls -la` (hidden files, owners), `readlink -f` (where a symlink really goes), `find . -xtype l` (broken symlinks),
`file` (what is this file really), `diff` (compare with a good copy), `sudo chown`, `chmod`, `ln -sfn`.

## Graded challenge
```
copycat-setup 40
cd ~/labs/40-system-recovery/app
ls -la
./bin/run.sh
```
The application should print `app running v1`. Several things were damaged at once:
- the launcher script cannot be executed
- the `current` link points at a release that does not exist (releases `v1` and `v0` exist)
- the configuration file has been truncated to nothing, but a good copy exists next to it
- a data folder is owned by the wrong user, so the app cannot write to it

Repair it **without deleting any files**, then run `./bin/run.sh` yourself until it prints `app running v1`.

Then:
```
copycat-check 40
```

## Check yourself
- Which clue pointed to each of the four faults?
- Which fault would a monitoring system miss, and why?
- What would you add so this could be restored automatically next time?

## Done
Score 100 in `copycat-check 40`, or `copycat-done 40`.
