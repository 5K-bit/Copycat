#!/bin/bash
. /usr/local/lib/copycat/grade.sh
d=/srv/hardening
mode() { stat -c %a "$1" 2>/dev/null; }

grade_start 39 "LINUX HARDENING"

grade_section "Insecure permissions"
item "/srv/hardening is missing: run copycat-setup 39 first" test -d "$d"
item "app.conf must not be writable by group or others" test "$(( 0$(mode "$d/app.conf") & 022 ))" -eq 0
item "app.conf must still exist (do not delete it)" test -f "$d/app.conf"

grade_section "Special bits"
item "viewer must not be setuid or setgid" test "$(( 0$(mode "$d/viewer") & 06000 ))" -eq 0
item "viewer must still be executable" test -x "$d/viewer"

grade_section "Secrets"
item "db-password.txt must not be accessible to group or others" test "$(( 0$(mode "$d/db-password.txt") & 077 ))" -eq 0
item "db-password.txt must still exist (do not delete it)" test -f "$d/db-password.txt"

grade_section "Accounts"
item "guest must be locked (passwd -l guest)" bash -c "sudo -n /usr/bin/passwd -S guest 2>/dev/null | awk '{print \$2}' | grep -qx L"

grade_finish
