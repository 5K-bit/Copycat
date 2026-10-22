# Lab 37 — Git fundamentals  (about 35 min, graded)

**Challenge:** track configuration changes and restore an earlier version.

## Concepts
- Git records **commits** (snapshots with a message). `git log` shows history; `git diff` shows changes; `git show` shows one commit.
- The three places: working folder -> **staging** (`git add`) -> **repository** (`git commit`).
- Undo safely: `git restore FILE` (discard edits), `git revert COMMIT` (a *new* commit that undoes an old one; history is kept).
  Prefer `revert` for shared history; `reset --hard` rewrites history and destroys work.

## Warm-up
```
mkdir -p /tmp/g && cd /tmp/g && git init -q . && git config user.name You && git config user.email you@example.invalid
echo one > f && git add f && git commit -qm "first"
echo two >> f && git commit -qam "second"
git log --oneline ; git diff HEAD~1 ; git restore --source=HEAD~1 f ; cat f
```

## Graded challenge
```
copycat-setup 37
cd ~/labs/37-git-fundamentals/config-repo
git log --oneline
cat app.conf
```
Someone changed `timeout=30` to `timeout=0` ("tuning") and the application hangs. 
1. Find the commit that broke it (`git log -p`, `git show`).
2. Restore `timeout=30` **without rewriting history** (use `git revert` of the bad commit, or restore the file and commit).
3. Leave the repository clean (no uncommitted changes) and keep the original commits in the log.

Then:
```
copycat-check 37
```

## Check yourself
- What is the difference between `git revert` and `git reset --hard`?
- How would you see who changed a line, and when? (`git blame`)
- Why keep `/etc`-style configuration in git?

## Done
Score 100 in `copycat-check 37`, or `copycat-done 37`.
