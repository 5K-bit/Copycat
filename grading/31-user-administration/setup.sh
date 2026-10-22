#!/bin/bash
# Lab 31: remove any earlier attempt so the student starts clean.
userdel -r taylor 2>/dev/null
groupdel interns 2>/dev/null
rm -rf /srv/interns
cat <<'EOF'
Challenge ready. Create the intern account and shared folder described in the lab README
(user taylor, groups students + interns, /srv/interns mode 2770, password max age 90 days).
Then run:  copycat-check 31
EOF
