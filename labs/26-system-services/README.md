# Lab 26 — System services  (about 25 min)

**Question:** how do I start, stop, enable and troubleshoot a Linux service?

On a normal server systemd manages services (`systemctl`). A container has no systemd, so Copycat uses
the older `service` command and init scripts, which work the same way in spirit: a script that knows how to
`start`, `stop`, `status`.

## Steps
1. See the services this machine runs and their scripts:
   ```
   ls /etc/init.d
   service --status-all 2>&1 | head
   ```
2. Control one. `ssh` is real; `copycat-app` is a small practice application:
   ```
   service ssh status
   sudo service copycat-app start       # password: copycat
   service copycat-app status
   curl -s http://localhost:8080
   sudo service copycat-app stop
   curl -s -m 3 http://localhost:8080 || echo "not answering"
   ```
3. Read what a start script does, then see the process it created:
   ```
   cat /etc/init.d/copycat-app
   ps aux | grep [c]opycat-app
   ```
4. Troubleshooting order that works for any service:
   1. Is it running? (`service X status`, `ps`, `ss -ltnp`)
   2. What does its log say? (`/var/log/...`)
   3. What does its config say? (`/etc/...`)
   4. Fix, restart, test from outside (`curl`, `ss`).
5. On a systemd machine the same ideas read: `systemctl status X`, `journalctl -u X`, `systemctl enable X`
   (start at boot), `systemctl restart X`.

## Check yourself
- What does "enabled" mean compared with "running"?
- If `status` says running but `curl` fails, what would you check next?
- Why is "restart" not a substitute for reading the log?

## Challenge
Start `copycat-app`, find its listening port with `ss -ltnp`, stop it, change `PORT=` in `/etc/copycat-app.conf`
to 8090, start it again and prove it listens there.

## Done
```
copycat-done 26
```
