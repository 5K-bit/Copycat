#!/bin/bash
# Grades the lab 06 challenge: ownership and mode via stat, plus a check the text survived.
. /usr/local/lib/copycat/grade.sh
f="$HOME/labs/06-permissions/challenge/report.txt"

grade_start 06 "FILE PERMISSIONS"

grade_section "File ownership"
item "report.txt is missing: run copycat-setup 06 first" test -e "$f"
item "the owner must be copycat (see: chown)" test "$(stat -c %U "$f" 2>/dev/null)" = copycat

grade_section "Group permissions"
item "the group must be students (see: chgrp / chown user:group)" test "$(stat -c %G "$f" 2>/dev/null)" = students
item "students must be able to read the file" test "$(( 0$(stat -c %a "$f" 2>/dev/null) & 040 ))" -ne 0
item "students must NOT be able to write the file" test "$(( 0$(stat -c %a "$f" 2>/dev/null) & 020 ))" -eq 0

grade_section "Security requirements"
item "other must have no access at all (the last digit of the mode is 0)" test "$(( 0$(stat -c %a "$f" 2>/dev/null) & 007 ))" -eq 0
item "the owner must be able to read the file" test -r "$f"
item "the report must still contain its original text (fix the file, do not replace it)" grep -q "Quarterly report" "$f"

grade_finish
