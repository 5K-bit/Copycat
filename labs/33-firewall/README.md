# Lab 33 — Firewall administration  (about 35 min, graded)

**Challenge:** write firewall rules and verify which traffic they allow.

Copycat's containers have no `NET_ADMIN` (on purpose), so real `iptables` cannot change anything here.
You write real **iptables-style rules**, and `fwsim` shows what they would allow or block.
The thinking is the same as on a real server.

## Concepts
- A firewall checks each packet against rules **top to bottom**; the first match wins. If none match, the **policy** decides.
- Best practice: policy **DROP**, then allow only what you need.
- `-A INPUT` appends a rule to the incoming-traffic chain. Common matches: `-p tcp`, `-s 10.0.0.0/24` (source), `--dport 22` (destination port), `-m state --state ESTABLISHED,RELATED` (replies to connections we started).
- Order matters: put specific rules before general ones.

## Warm-up
```
cd ~/labs/33-firewall
cat packets.txt          # sample packets: PROTO SRC DST DPORT [state=ESTABLISHED]
cat example-rules.txt
fwsim example-rules.txt packets.txt
```

## Graded challenge
Write `~/labs/33-firewall/rules.txt` for a web server so that:
1. The default policy for incoming traffic is **DROP**.
2. Replies to connections the server started are accepted (`ESTABLISHED,RELATED`).
3. **SSH (tcp 22)** is allowed **only from the admin network `10.0.0.0/24`**.
4. **HTTP (tcp 80) and HTTPS (tcp 443)** are allowed from anywhere.
5. Everything else (telnet, database ports, DNS from the Internet...) is blocked.

Test your own rules as often as you like with `fwsim rules.txt packets.txt`; add your own packets to a copy of the file.
Then:
```
copycat-check 33
```

## Check yourself
- Why must the `ESTABLISHED` rule exist when the policy is DROP?
- What happens if you put `-A INPUT -p tcp --dport 22 -j ACCEPT` before the admin-only SSH rule?
- Why is "default DROP" safer than "default ACCEPT plus blocking known bad ports"?

## Done
Score 100 in `copycat-check 33`, or `copycat-done 33`.
