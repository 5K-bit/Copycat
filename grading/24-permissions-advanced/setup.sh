#!/bin/bash
# Lab 24 challenge: a team area with wrong group/bits, no ACL, and a setuid helper.
d=/srv/lab24
rm -rf "$d"
mkdir -p "$d/shared" "$d/tools"
echo "Team handbook" > "$d/shared/handbook.txt"
printf '#!/bin/bash\necho report\n' > "$d/tools/report"
chown -R root:root "$d"
chmod 755 "$d" "$d/tools"
chmod 775 "$d/shared"                    # wrong: others can enter, no setgid/sticky, wrong group
chmod 644 "$d/shared/handbook.txt"       # wrong: others can read
chmod 4755 "$d/tools/report"             # wrong: setuid
cat <<'EOF'
Challenge ready: /srv/lab24
Fix it (sudo, password: copycat) so that:
  1. shared/ has group developers, setgid + sticky, and no access for others (mode 3770)
  2. sam can READ but not write shared/handbook.txt through an ACL; others get no access to it
  3. tools/report is no longer setuid or setgid
Then run:  copycat-check 24
EOF
