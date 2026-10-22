#!/bin/bash
. /usr/local/lib/copycat/grade.sh
d="$HOME/labs/40-system-recovery/app"

grade_start 40 "SYSTEM RECOVERY"

grade_section "Launcher"
item "bin/run.sh must exist (run copycat-setup 40 first)" test -f "$d/bin/run.sh"
item "bin/run.sh must be executable" test -x "$d/bin/run.sh"

grade_section "Release link"
item "current must point at an existing release" test -e "$d/current/VERSION"
item "current must point at v1" test "$(readlink "$d/current" 2>/dev/null | sed 's#/$##')" = releases/v1

grade_section "Configuration"
item "config/app.conf must not be empty" test -s "$d/config/app.conf"
item "config/app.conf must match the good copy" cmp -s "$d/config/app.conf" "$d/config/app.conf.good"

grade_section "Data folder"
item "data/ must be writable by copycat" bash -c "touch '$d/data/.t' && rm -f '$d/data/.t'"

grade_section "Result"
item "./bin/run.sh must print 'app running v1'" bash -c "[ \"\$('$d/bin/run.sh' 2>/dev/null)\" = 'app running v1' ]"
item "no files were deleted (good config and both releases still exist)" bash -c "test -f '$d/config/app.conf.good' && test -d '$d/releases/v0' && test -d '$d/releases/v1'"

grade_finish
