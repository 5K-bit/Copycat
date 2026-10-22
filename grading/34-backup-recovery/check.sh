#!/bin/bash
. /usr/local/lib/copycat/grade.sh
d="$HOME/labs/34-backup-recovery"
new="$d/backup/site-restored.tar.gz"

grade_start 34 "BACKUP AND RECOVERY"

grade_section "Restore"
item "site/settings.conf must be restored (copycat-setup 34 first if the lab is missing)" test -f "$d/site/settings.conf"
item "the restored file must have max_users=250 (the right archive)" grep -qx 'max_users=250' "$d/site/settings.conf"
item "the other site files must be untouched" bash -c "grep -q Welcome '$d/site/index.html' && grep -q user2 '$d/site/users.txt'"

grade_section "New backup"
item "backup/site-restored.tar.gz must exist" test -f "$new"
item "the new archive must be valid (gzip -t)" gzip -t "$new"
item "the new archive must contain site/settings.conf" bash -c "tar -tzf '$new' 2>/dev/null | grep -qx 'site/settings.conf'"
item "the archived settings.conf must have max_users=250" bash -c "tar -xzOf '$new' site/settings.conf 2>/dev/null | grep -qx 'max_users=250'"

grade_section "Original backups kept"
item "the original backups must still exist" test -f "$d/backup/site-lastnight.tar.gz" -a -f "$d/backup/site-lastmonth.tar.gz"

grade_finish
