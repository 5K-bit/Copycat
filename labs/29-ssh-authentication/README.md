# Lab 29 — SSH authentication  (about 30 min, graded)

**Question:** how do SSH keys work, and why might authentication fail?

## Concepts
- A **key pair** has a private key (stays on your machine, mode `600`) and a public key (copied to servers).
- The server keeps allowed public keys in `~/.ssh/authorized_keys`. At login your client proves it holds the matching private key without ever sending it.
- Password login still works until key-only login is configured and tested.
- Common failures: wrong permissions (sshd ignores keys if `~/.ssh` or `authorized_keys` is writable by others), the wrong key offered, the public key not installed, `sshd_config` disallowing keys.

## Graded challenge
```
copycat-setup 29
```
Set up key-based login from `copycat-kali` to `student@copycat-target` (password `student`) with a **new key called `lab29`**:
```
ssh-keygen -t ed25519 -f ~/.ssh/id_lab29 -N ''
sshpass -p student ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_lab29.pub student@copycat-target
ssh -i ~/.ssh/id_lab29 -o IdentitiesOnly=yes student@copycat-target hostname
```
(`-N ''` makes a key with no passphrase, fine for a lab; use a passphrase on real keys.)

When the last command prints the target's hostname *without asking for a password*, grade it:
```
copycat-check 29
```
If it fails, add `-v` to the `ssh` command and read which keys were offered and why they were refused. On the target you can also look at `ls -la ~/.ssh` and `sudo tail /var/log/auth.log` (the target's `sam`/`student` accounts are on a separate machine; log in as `student`).

## Check yourself
- Which file holds the server's list of allowed keys? Which file holds your private key?
- Why does sshd refuse keys when `~/.ssh` is writable by everyone?
- What does `IdentitiesOnly=yes` stop your client from doing?

## Done
Score 100 in `copycat-check 29`, or `copycat-done 29`.
