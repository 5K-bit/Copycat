# Lab 10 — SSH  (about 15 min)

**Goal:** log in to another machine, then log in without a password using keys.

**Start here:** `cd ~`

The target's prompt is yellow `=^-^=` so you can tell the two machines apart.

## Steps

1. Log in:
   ```
   ssh student@copycat-target
   ```
   The first time it asks `Are you sure you want to continue connecting`. Type `yes`. Password:
   `student`.
2. Look around, then leave:
   ```
   whoami
   hostname
   who
   exit
   ```
   After `exit` your prompt turns back into `copycat-kali`.
3. Run one command remotely without a shell:
   ```
   ssh student@copycat-target 'hostname; ls'
   ```
4. Make a key pair and install the public half:
   ```
   ssh-keygen
   ssh-copy-id student@copycat-target
   ssh student@copycat-target
   exit
   ```
   Press Enter for each `ssh-keygen` question (the default path, an empty passphrase is fine
   for a lab). The last login should NOT ask for a password.
5. See what you made:
   ```
   ls ~/.ssh
   cat ~/.ssh/known_hosts
   ```
6. See the server's side of it:
   ```
   sudo grep sshd /var/log/auth.log | tail
   ```

## Check yourself
- Which file is private and must never be shared: `id_ed25519` or `id_ed25519.pub`?
- What does `known_hosts` protect you from?
- What would `ssh -p 2222 copycat@127.0.0.1` do from inside the lab?

## Challenge
Log in to the target and from there, with one command, print the file
`/home/student/welcome.txt` back on your own screen without staying logged in.

## Done
```
copycat-done 10
```

Broke something? Run `copycat-reset` on your PC (not in here).
