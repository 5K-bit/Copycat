# Lab 09 — Networking  (about 15 min)

**Goal:** see this machine's network setup and talk to the second machine, `copycat-target`.

**Start here:** `cd ~`

## Steps

1. Your own network:
   ```
   hostname -I
   ip addr
   ip route
   ss -tuln
   ```
   `ip route` shows the default gateway. `ss -tuln` lists listening ports (22 for ssh).
2. Is the other machine up, and what is its address?
   ```
   ping -c3 copycat-target
   getent hosts copycat-target
   traceroute copycat-target
   ```
   A name became an IP address through Docker's built-in DNS.
3. Ask DNS directly:
   ```
   cat /etc/resolv.conf
   dig copycat-target
   nslookup copycat-target
   ```
   Look at the `ANSWER SECTION` in the `dig` output.
4. Fetch web pages:
   ```
   curl http://copycat-target
   curl -I http://copycat-target
   wget http://copycat-target/files/numbers.txt
   cat numbers.txt
   ```
   `-I` shows only the response headers. `wget` saves the file in the current folder.
5. Look closer at one request:
   ```
   curl -v http://copycat-target/files/ 2>&1 | head -20
   ```

## Check yourself
- What is the IP address of `copycat-target`, and is it in the same range as yours?
- Which port is the web server on? (Hint: it is the default for http.)
- What is the difference between `curl` and `wget` for the same URL?

## Challenge
Download `employees.csv` from the target's `/files/` folder and print its second column.

## Done
```
copycat-done 09
```

Broke something? Run `copycat-reset` on your PC (not in here).
