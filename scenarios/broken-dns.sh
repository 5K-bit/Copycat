# shellcheck shell=bash disable=SC2034
S_QUESTION="Why does a hostname fail to resolve?"
S_TITLE="NAME RESOLUTION"
BACKUP=/var/lib/copycat-trouble.resolv.conf

s_symptom() {
  ip=$(getent hosts -- copycat-target 2>/dev/null | awk '{print $1}')
  cat <<EOF
Reaching the other machine by name fails:   ping -c1 copycat-target     ("Temporary failure in name resolution")
Yet the network is fine: pinging its address works.   ${ip:+ping -c1 $ip}
Make the name work again, without adding a hard-coded line to /etc/hosts.
EOF
}

s_break() {
  [ -f "$BACKUP" ] || cp /etc/resolv.conf "$BACKUP"
  printf 'nameserver 192.0.2.1\noptions timeout:1 attempts:1\n' > /etc/resolv.conf
}

s_reset() { [ -f "$BACKUP" ] && cat "$BACKUP" > /etc/resolv.conf; rm -f "$BACKUP"; true; }
s_fix() { printf 'nameserver 127.0.0.11\noptions ndots:0\n' > /etc/resolv.conf; }

s_verify() {
  grade_section "Resolver"
  item "/etc/resolv.conf points at Docker's resolver (127.0.0.11)" grep -q '^nameserver 127.0.0.11' /etc/resolv.conf
  grade_section "Names resolve"
  item "copycat-target resolves" timeout 8 getent hosts copycat-target
  item "ping copycat-target works" ping -c1 -W3 copycat-target
  grade_section "No shortcuts"
  item "/etc/hosts has no hard-coded copycat-target line" bash -c "! grep -q copycat-target /etc/hosts"
}

s_hint1() { echo "Hint 1: IP works, name fails => the lookup step. Which server does this machine ask? cat /etc/resolv.conf"; }
s_hint2() { echo "Hint 2: that nameserver address is not a real resolver here. Docker's built-in one is 127.0.0.11. Edit with sudo."; }
s_reveal() {
  cat <<'EOF'
Cause: /etc/resolv.conf listed nameserver 192.0.2.1 (a documentation address nobody answers on), so every
       lookup timed out. Pings by IP never need DNS, which is the clue that DNS is the layer that broke.
Fix:   echo 'nameserver 127.0.0.11' | sudo tee /etc/resolv.conf
Tools: getent hosts NAME (what programs see), dig NAME @127.0.0.11 (ask a specific server)
EOF
}
