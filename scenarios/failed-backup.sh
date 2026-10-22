# shellcheck shell=bash disable=SC2034
S_QUESTION="Why didn't the recovery process work?"
S_TITLE="FAILED BACKUP"
B=/srv/backup

s_symptom() {
  cat <<'EOF'
/srv/app/app.conf was deleted by accident. The newest backup is /srv/backup/app-backup.tar.gz:
    tar -xzf /srv/backup/app-backup.tar.gz -C /srv/app
but the restore fails. Bring back app.conf (its content has "setting=ok") and work out what went wrong.
EOF
}

s_break() {
  rm -rf /srv/app "$B"
  mkdir -p /srv/app "$B" /tmp/cc-bk
  printf '# app configuration\nsetting=ok\nmode=production\n' > /tmp/cc-bk/app.conf
  tar -czf "$B/app-backup.1.tar.gz" -C /tmp/cc-bk app.conf          # last week: good
  tar -czf "$B/app-backup.tar.gz" -C /tmp/cc-bk app.conf            # newest ...
  head -c 60 "$B/app-backup.tar.gz" > "$B/app-backup.tar.gz.part" && mv "$B/app-backup.tar.gz.part" "$B/app-backup.tar.gz"   # ... cut short
  rm -rf /tmp/cc-bk
  chown -R copycat:copycat /srv/app /srv/backup
}

s_reset() { rm -rf /srv/app /srv/backup /tmp/cc-bk; }
s_fix() { tar -xzf "$B/app-backup.1.tar.gz" -C /srv/app; chown -R copycat:copycat /srv/app; }

s_verify() {
  grade_section "Restored"
  item "/srv/app/app.conf exists" test -f /srv/app/app.conf
  item "it contains setting=ok" grep -qx 'setting=ok' /srv/app/app.conf
  grade_section "Evidence kept"
  item "the backups were not deleted" test -f "$B/app-backup.1.tar.gz" -a -f "$B/app-backup.tar.gz"
  grade_section "Understood"
  item "the good archive is still valid (gzip -t)" gzip -t "$B/app-backup.1.tar.gz"
}

s_hint1() { echo "Hint 1: read the exact error, then test the archive without extracting it: gzip -t FILE ; tar -tzf FILE ; ls -l /srv/backup"; }
s_hint2() { echo "Hint 2: the newest archive is truncated. Is there an older backup in the same folder that passes gzip -t?"; }
s_reveal() {
  cat <<'EOF'
Cause: app-backup.tar.gz is truncated (the backup job was cut off, so it is not a complete gzip stream).
       tar fails with "Unexpected EOF in archive". A backup is only good if you have tested a restore.
Find:  gzip -t /srv/backup/*.tar.gz     (the broken one errors, the older one is silent)
Fix:   tar -xzf /srv/backup/app-backup.1.tar.gz -C /srv/app
Lesson: verify backups (gzip -t, tar -tzf, a test restore); keep more than one copy.
EOF
}
