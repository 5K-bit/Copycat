# shellcheck shell=bash disable=SC2034
S_QUESTION="Why can't the server save files?"
S_TITLE="DISK FULL"
M=/mnt/smalldisk

s_symptom() {
  cat <<'EOF'
The app can't save anything to /mnt/smalldisk any more. Try:   echo hello > /mnt/smalldisk/test.txt
Free space without deleting the app's database, /mnt/smalldisk/app.db.
EOF
}

s_break() {
  rm -rf "${M:?}"/* "$M"/.cache 2>/dev/null
  echo "important application data" > "$M/app.db"
  mkdir -p "$M/.cache/tmp"
  dd if=/dev/zero of="$M/.cache/tmp/render.cache" bs=1M status=none 2>/dev/null   # runs until the disk is full
  true
}

s_reset() { rm -rf "${M:?}"/* "$M"/.cache 2>/dev/null; true; }
s_fix() { rm -rf "$M/.cache"; }

s_verify() {
  grade_section "Space"
  item "at least 4 MB are free on /mnt/smalldisk" test "$(df -Pm "$M" | awk 'NR==2{print $4}')" -ge 4
  grade_section "Writes work"
  item "a new 1 MB file can be written" bash -c "dd if=/dev/zero of=$M/write-test bs=1M count=1 status=none && rm -f $M/write-test"
  grade_section "Data kept"
  item "app.db is still there and intact" grep -q "important application data" "$M/app.db"
}

s_hint1() { echo "Hint 1: df -h shows which filesystem is full; du -sh /mnt/smalldisk/* /mnt/smalldisk/.[!.]* shows what fills it (hidden entries too)."; }
s_hint2() { echo "Hint 2: look for a big file in a hidden folder (ls -la). Delete the cache, not app.db."; }
s_reveal() {
  cat <<'EOF'
Cause: a runaway cache file (.cache/tmp/render.cache) filled the whole 8 MB disk. A full disk makes
       every write fail with "No space left on device", even for tiny files.
Fix:   rm -rf /mnt/smalldisk/.cache        (hidden entries do not show in plain ls: use ls -la)
Check: df -h /mnt/smalldisk
EOF
}
