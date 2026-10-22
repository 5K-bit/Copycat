# Lab 32 — Service troubleshooting  (about 30 min)

**Challenge:** diagnose why an HTTP or SSH service stopped responding.

This lab uses troubleshooting mode: Copycat breaks something real, you find the cause.

## The method (use it every time)
1. **Reproduce**: see the exact failure yourself (`curl -v`, `ssh -v`).
2. **State**: is the service running? (`service X status`, `ps`, `ss -ltnp`)
3. **Logs**: what did it say when it failed? (`/var/log/auth.log`, the app's own log or error file)
4. **Config**: what changed? (`/etc/...`)
5. **Fix, restart, test from outside.**

## Scenario A — the HTTP application is down
```
copycat-trouble start failed-service
curl -v http://localhost:8080
service copycat-app status
cat /var/log/copycat-app.err
```
Fix it, then grade it:
```
copycat-trouble check
```

## Scenario B — a user cannot SSH in
```
copycat-trouble start broken-ssh
ssh sam@localhost          # password: password
sudo tail /var/log/auth.log
grep -n -i -E 'deny|allow' /etc/ssh/sshd_config
copycat-trouble check
```

Stuck? `copycat-trouble hint` (run twice for a bigger hint). Give up? `copycat-trouble reveal` explains the cause.
Run `copycat-trouble reset` when you finish a scenario.

## Check yourself
- For each scenario, which step of the method found the cause?
- Why check the *log* before changing the config?

## Challenge
Run `copycat-trouble start random` three times without hints and note which step of the method solved each one.

## Done
```
copycat-done 32
```
