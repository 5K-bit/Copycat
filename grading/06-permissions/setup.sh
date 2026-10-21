#!/bin/bash
# Challenge for lab 06: ~/labs/06-permissions/challenge/report.txt is locked away.
# Run by copycat-setup through sudo (so it runs as root; the student has a NOPASSWD rule for it).
dir=/home/copycat/labs/06-permissions/challenge
rm -rf "$dir"
mkdir -p "$dir"
echo "Quarterly report: draft" > "$dir/report.txt"
chown -R root:root "$dir"        # the folder stays root's, so the student must fix the file, not replace it
chmod 755 "$dir"
chmod 600 "$dir/report.txt"
cat <<EOF
Challenge ready: ~/labs/06-permissions/challenge/report.txt
You cannot read it. Find out why, then fix it so that:
  - copycat owns the file
  - the group "students" can read it but not change it
  - nobody else (other) has any access at all
Investigate with:  ls -l   id   groups   stat report.txt
(you will need sudo for the fix; password: copycat)
Then run:          copycat-check 06
EOF
