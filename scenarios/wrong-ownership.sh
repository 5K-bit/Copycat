# shellcheck shell=bash disable=SC2034
S_QUESTION="Why can't a user modify a file?"
S_TITLE="WRONG OWNERSHIP"
F=/srv/team/notes.txt

s_symptom() {
  cat <<'EOF'
The developers team (alex and jordan) must be able to edit /srv/team/notes.txt, but:
    sudo -u alex bash -c 'echo hi >> /srv/team/notes.txt'     says Permission denied.
Make the file editable by the developers group, and only by them (others get read at most).
EOF
}

s_break() {
  rm -rf /srv/team
  mkdir -p /srv/team
  echo "team notes" > "$F"
  chown root:root "$F"
  chmod 644 "$F"
}

s_reset() { rm -rf /srv/team; }
s_fix() { chgrp developers "$F"; chmod 664 "$F"; }

s_verify() {
  grade_section "Group ownership"
  item "the file's group is developers" test "$(stat -c %G "$F" 2>/dev/null)" = developers
  grade_section "Group permissions"
  item "the group can write the file" test "$(( 0$(stat -c %a "$F" 2>/dev/null) & 020 ))" -ne 0
  item "the group can read the file" test "$(( 0$(stat -c %a "$F" 2>/dev/null) & 040 ))" -ne 0
  grade_section "Security requirements"
  item "others cannot write the file" test "$(( 0$(stat -c %a "$F" 2>/dev/null) & 002 ))" -eq 0
  item "the original text is intact" grep -q "team notes" "$F"
}

s_hint1() { echo "Hint 1: ls -l /srv/team/notes.txt; id alex; getent group developers. Who may write it, and who needs to?"; }
s_hint2() { echo "Hint 2: change the group (chgrp / chown :group) and the group's write bit (chmod g+w). You need sudo."; }
s_reveal() {
  cat <<'EOF'
Cause: the file belonged to root:root with mode 644, so only root could write it; alex is neither root
       nor in root's group, and "others" only get read.
Fix:   sudo chgrp developers /srv/team/notes.txt ; sudo chmod 664 /srv/team/notes.txt
       (664 = owner rw, group rw, others r)
Test:  sudo -u alex bash -c 'echo hi >> /srv/team/notes.txt'
EOF
}
