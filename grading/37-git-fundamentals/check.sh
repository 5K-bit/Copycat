#!/bin/bash
. /usr/local/lib/copycat/grade.sh
r="$HOME/labs/37-git-fundamentals/config-repo"
g() { git -C "$r" "$@"; }

grade_start 37 "GIT FUNDAMENTALS"

grade_section "Configuration restored"
item "app.conf must exist (run copycat-setup 37 first)" test -f "$r/app.conf"
item "timeout must be 30 again" grep -qx 'timeout=30' "$r/app.conf"
item "the other settings must be intact (name=shop, retries=3)" bash -c "grep -qx 'name=shop' '$r/app.conf' && grep -qx 'retries=3' '$r/app.conf'"

grade_section "History preserved"
item "the original 3 commits must still be in the log (do not reset or rewrite)" bash -c "git -C '$r' log --format=%s | grep -qx 'Initial config' && git -C '$r' log --format=%s | grep -qx 'Tune timeout for speed' && git -C '$r' log --format=%s | grep -qx 'Add a comment'"
item "your fix must be a new commit (at least 4 commits)" test "$(g rev-list --count HEAD 2>/dev/null || echo 0)" -ge 4

grade_section "Clean repository"
item "no uncommitted changes (commit your fix)" test -z "$(g status --porcelain 2>/dev/null)"

grade_finish
