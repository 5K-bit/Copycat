d=/srv/hardening
chmod 644 "$d/app.conf"
chmod 755 "$d/viewer"
chmod 600 "$d/db-password.txt"
passwd -l guest
