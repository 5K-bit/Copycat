# shellcheck shell=bash disable=SC2034
S_QUESTION="Why can't a script execute?"
S_TITLE="SCRIPT WON'T RUN"
D=/home/copycat/trouble/scripts

s_symptom() {
  cat <<'EOF'
The nightly job ~/trouble/scripts/nightly.sh fails with "Permission denied" and nobody can say why.
Make it run and print "nightly ok", without making it world-writable.
EOF
}

s_break() {
  rm -rf /home/copycat/trouble
  mkdir -p "$D"
  printf '#!/bin/bash\necho nightly ok\n' > "$D/nightly.sh"
  chown -R copycat:copycat /home/copycat/trouble
  chmod 644 "$D/nightly.sh"    # not executable
  chmod 644 "$D"               # and the folder cannot be entered
}

s_reset() { rm -rf /home/copycat/trouble; }
s_fix() { chmod 755 "$D"; chmod 755 "$D/nightly.sh"; }

s_verify() {
  grade_section "Folder access"
  item "the scripts folder can be entered (it needs the x bit)" test -x "$D"
  grade_section "Script runs"
  item "nightly.sh is executable" test -x "$D/nightly.sh"
  item "running it prints 'nightly ok'" test "$("$D/nightly.sh" 2>/dev/null)" = "nightly ok"
  grade_section "Security requirements"
  item "nightly.sh is not writable by others" test "$(( 0$(stat -c %a "$D/nightly.sh" 2>/dev/null) & 002 ))" -eq 0
  item "the folder is not writable by others" test "$(( 0$(stat -c %a "$D" 2>/dev/null) & 002 ))" -eq 0
}

s_hint1() { echo "Hint 1: run the script and read the exact error, then ls -l the file AND ls -ld its folder."; }
s_hint2() { echo "Hint 2: two things are wrong. A file needs x to run; a directory needs x to be entered. Compare modes with stat."; }
s_reveal() {
  cat <<'EOF'
Cause: nightly.sh was mode 644 (no execute bit) and the scripts folder was mode 644 (no x, so
       you cannot even reach the file inside). Fixing only the file still fails.
Fix:   chmod 755 ~/trouble/scripts ; chmod 755 ~/trouble/scripts/nightly.sh
Remember: files need x to run, directories need x to be entered.
EOF
}
