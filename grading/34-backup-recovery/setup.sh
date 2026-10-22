#!/bin/bash
# Lab 34: a site folder, a good backup of it, and the config file deleted by accident.
d=/home/copycat/labs/34-backup-recovery
rm -rf "$d"
mkdir -p "$d/site" "$d/backup"
printf 'name=shop\nmax_users=250\nmode=production\n' > "$d/site/settings.conf"
printf '<h1>Welcome</h1>\n' > "$d/site/index.html"
printf 'user1\nuser2\n' > "$d/site/users.txt"
tar -czf "$d/backup/site-lastnight.tar.gz" -C "$d" site
# an older, different archive to make the student choose by content, not by name
mkdir -p /tmp/cc34 && cp -a "$d/site" /tmp/cc34/ && sed -i 's/max_users=250/max_users=10/' /tmp/cc34/site/settings.conf
tar -czf "$d/backup/site-lastmonth.tar.gz" -C /tmp/cc34 site
rm -rf /tmp/cc34
rm -f "$d/site/settings.conf"
chown -R copycat:copycat "$d"
cat <<'EOF'
Challenge ready: ~/labs/34-backup-recovery
settings.conf was deleted from site/. Restore that one file from the right backup (it must say max_users=250),
then create backup/site-restored.tar.gz of the repaired site and test it.  Then run:  copycat-check 34
EOF
