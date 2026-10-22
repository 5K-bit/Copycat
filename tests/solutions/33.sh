cat > /home/copycat/labs/33-firewall/rules.txt <<'RULES'
-P INPUT DROP
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p tcp -s 10.0.0.0/24 --dport 22 -j ACCEPT
-A INPUT -p tcp --dport 80 -j ACCEPT
-A INPUT -p tcp --dport 443 -j ACCEPT
RULES
chown copycat:copycat /home/copycat/labs/33-firewall/rules.txt
