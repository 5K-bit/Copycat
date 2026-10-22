#!/bin/bash
. /usr/local/lib/copycat/grade.sh
rules="$HOME/labs/33-firewall/rules.txt"
t=$(mktemp)
trap 'rm -f "$t"' EXIT

# verdict PROTO SRC DST DPORT [extra]  -> prints ACCEPT or DROP using the student's rules
verdict() {
  printf '%s\n' "$*" > "$t"
  fwsim "$rules" "$t" 2>/dev/null | awk '{print $1}'
}
expect() { # expect ACCEPT|DROP "packet fields..."
  want=$1; shift
  [ "$(verdict "$@")" = "$want" ]
}

grade_start 33 "FIREWALL ADMINISTRATION"

grade_section "Default policy"
item "rules.txt must exist in ~/labs/33-firewall (run copycat-setup 33)" test -s "$rules"
item "the INPUT policy must be DROP (-P INPUT DROP)" grep -Eq '^-P[[:space:]]+INPUT[[:space:]]+DROP' "$rules"
item "replies to our own connections must be accepted (ESTABLISHED,RELATED)" expect ACCEPT tcp 198.51.100.7 10.0.0.1 40000 80 state=established

grade_section "Allowed traffic"
item "SSH from the admin network 10.0.0.0/24 is allowed" expect ACCEPT tcp 10.0.0.5 10.0.0.1 22
item "HTTP from anywhere is allowed" expect ACCEPT tcp 203.0.113.9 10.0.0.1 80
item "HTTPS from anywhere is allowed" expect ACCEPT tcp 203.0.113.9 10.0.0.1 443

grade_section "Security requirements"
item "SSH from the Internet must be blocked" expect DROP tcp 203.0.113.9 10.0.0.1 22
item "SSH from another private range (192.168.1.5) must be blocked" expect DROP tcp 192.168.1.5 10.0.0.1 22
item "telnet (23) must be blocked" expect DROP tcp 10.0.0.5 10.0.0.1 23
item "database port 5432 must be blocked" expect DROP tcp 10.0.0.5 10.0.0.1 5432
item "DNS from the Internet (udp 53) must be blocked" expect DROP udp 8.8.8.8 10.0.0.1 53

grade_finish
