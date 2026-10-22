#!/bin/bash
# Lab 33: give the student a working folder with sample packets and an example (deliberately weak) ruleset.
d=/home/copycat/labs/33-firewall
mkdir -p "$d"
cat > "$d/packets.txt" <<'EOF'
# PROTO SRC DST DPORT [SPORT] [state=ESTABLISHED]
tcp 10.0.0.5 10.0.0.1 22
tcp 203.0.113.9 10.0.0.1 22
tcp 203.0.113.9 10.0.0.1 80
tcp 203.0.113.9 10.0.0.1 443
tcp 10.0.0.5 10.0.0.1 23
tcp 10.0.0.5 10.0.0.1 5432
udp 8.8.8.8 10.0.0.1 53
tcp 198.51.100.7 10.0.0.1 40000 80 state=established
EOF
cat > "$d/example-rules.txt" <<'EOF'
# A weak example: it accepts everything except telnet.
-P INPUT ACCEPT
-A INPUT -p tcp --dport 23 -j DROP
EOF
rm -f "$d/rules.txt"
chown -R copycat:copycat "$d"
cat <<'EOF'
Challenge ready: ~/labs/33-firewall
Write rules.txt there (see the lab README), test with:  fwsim rules.txt packets.txt
Then run:  copycat-check 33
EOF
