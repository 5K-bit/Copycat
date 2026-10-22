#!/bin/bash
# Lab 39: an insecurely configured area plus an account without a password.
d=/srv/hardening
rm -rf "$d"
mkdir -p "$d"
echo "setting=on" > "$d/app.conf"
printf '#!/bin/bash\ncat "$@"\n' > "$d/viewer"
echo "db_password=Sup3rSecret!" > "$d/db-password.txt"
chown -R root:root "$d"
chmod 755 "$d"
chmod 666 "$d/app.conf"
chmod 4755 "$d/viewer"
chmod 644 "$d/db-password.txt"
id guest >/dev/null 2>&1 || useradd -m -s /bin/bash guest
passwd -d guest >/dev/null 2>&1
cat <<'EOF'
Challenge ready: /srv/hardening and the account guest.
Audit and correct the four problems listed in the lab README (sudo password: copycat), keeping every file.
Then run:  copycat-check 39
EOF
