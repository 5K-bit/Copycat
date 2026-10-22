# shellcheck shell=bash disable=SC2034
# Scenario: a user cannot connect over SSH. Sourced by trouble-run.sh (root) and copycat-trouble.
S_QUESTION="Why can't a user connect?"
S_TITLE="BROKEN SSH"

s_symptom() {
  cat <<'EOF'
sam says: "I can't log in over SSH any more. It just says Permission denied."
Try it yourself:  ssh sam@localhost      (password: password)
Other people can still log in, so sshd itself is up. Find out what is different about sam.
EOF
}

s_break() {
  grep -q '^DenyUsers sam' /etc/ssh/sshd_config || echo 'DenyUsers sam' >> /etc/ssh/sshd_config
  service ssh reload >/dev/null 2>&1
}

s_reset() {
  sed -i '/^DenyUsers sam$/d' /etc/ssh/sshd_config
  service ssh reload >/dev/null 2>&1
}
s_fix() { s_reset; }

s_verify() {
  grade_section "sshd healthy"
  item "sshd is running" pgrep -x sshd
  grade_section "sam can log in"
  item "sam can log in with the password 'password'" \
    sshpass -p password ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=5 sam@localhost true
  grade_section "Nothing else broken"
  item "copycat can still log in" \
    sshpass -p copycat ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=5 copycat@localhost true
}

s_hint1() { echo "Hint 1: the password is right, so look at what the server decides before it checks it. Logs: /var/log/auth.log."; }
s_hint2() { echo "Hint 2: read /etc/ssh/sshd_config (grep -n -i -E 'deny|allow|match'). After any change, reload: sudo service ssh reload."; }
s_reveal() {
  cat <<'EOF'
Cause: sshd_config contained "DenyUsers sam", so sshd refuses sam before checking the password
       (auth.log says: "User sam from ... not allowed because listed in DenyUsers").
Fix:   sudo sed -i '/^DenyUsers sam$/d' /etc/ssh/sshd_config ; sudo service ssh reload
Habit: run "sudo sshd -t" before reloading so a typo cannot lock everyone out.
EOF
}
