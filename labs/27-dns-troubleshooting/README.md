# Lab 27 — DNS troubleshooting  (about 25 min)

**Question:** why can I reach an IP address but not its hostname?

Reaching a name takes two steps: **resolve** the name to an address (DNS), then **connect** to the address.
If the address works and the name does not, the first step is what broke.

## Steps
1. Look at the same target both ways:
   ```
   getent hosts copycat-target
   ping -c1 copycat-target
   ```
   Note the address `getent` printed, then `ping -c1 <that address>`.
2. Where does this machine look names up?
   ```
   cat /etc/nsswitch.conf | grep ^hosts      # order: files, then dns
   cat /etc/hosts                            # local overrides
   cat /etc/resolv.conf                      # which DNS server to ask
   ```
3. Ask a DNS server directly, and compare tools:
   ```
   dig +short copycat-target @127.0.0.11
   getent hosts copycat-target               # what programs really use
   host copycat-target
   ```
4. Practise the failure for real. Copycat breaks the resolver and you diagnose it:
   ```
   copycat-trouble start broken-dns
   ping -c1 copycat-target          # fails
   ping -c1 <the address from step 1>   # works
   cat /etc/resolv.conf
   copycat-trouble check            # after your fix
   ```
   (`copycat-trouble hint` helps; `copycat-trouble reveal` explains.)

## Check yourself
- Which file did the problem live in, and why does a ping by address still work?
- What is the difference between `dig` and `getent hosts`, and which one matches what your programs see?
- When is adding a line to `/etc/hosts` a reasonable fix, and when is it a cover-up?

## Challenge
Add `10.9.9.9 demo.local` to `/etc/hosts` (sudo), prove `getent hosts demo.local` finds it, then remove it.

## Done
```
copycat-done 27
```
