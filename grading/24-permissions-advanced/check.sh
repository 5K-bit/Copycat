#!/bin/bash
. /usr/local/lib/copycat/grade.sh
d=/srv/lab24
mode() { stat -c %a "$1" 2>/dev/null; }
# handbook.txt sits inside a folder the student's account may not enter, so read it through exact sudo rules
hmode() { sudo -n /usr/bin/stat -c %a /srv/lab24/shared/handbook.txt 2>/dev/null; }

grade_start 24 "ADVANCED PERMISSIONS"

grade_section "Group ownership"
item "/srv/lab24 does not exist: run copycat-setup 24 first" test -d "$d/shared"
item "shared/ must belong to the group developers" test "$(stat -c %G "$d/shared" 2>/dev/null)" = developers

grade_section "Special permission bits"
item "shared/ must be setgid (new files inherit the group)" test "$(( 0$(mode "$d/shared") & 02000 ))" -ne 0
item "shared/ must be sticky (users delete only their own files)" test "$(( 0$(mode "$d/shared") & 01000 ))" -ne 0
item "tools/report must not be setuid or setgid" test "$(( 0$(mode "$d/tools/report") & 06000 ))" -eq 0

grade_section "Access control list"
item "sam needs a read-only ACL entry on handbook.txt (setfacl -m u:sam:r)" bash -c "sudo -n /usr/bin/getfacl -p /srv/lab24/shared/handbook.txt 2>/dev/null | grep -q '^user:sam:r--\$'"
item "sam needs search (x) permission on the shared folder via an ACL" bash -c "getfacl -p '$d/shared' 2>/dev/null | grep -Eq '^user:sam:(--x|r-x)\$'"

grade_section "Security requirements"
item "others must have no access to shared/" test "$(( 0$(mode "$d/shared") & 007 ))" -eq 0
item "others must have no access to handbook.txt" test "$(( 0$(hmode) & 007 ))" -eq 0
item "handbook.txt content must be intact" sudo -n /usr/bin/grep -q Team /srv/lab24/shared/handbook.txt

grade_finish
