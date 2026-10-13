# Copycat

A Docker-based Linux and cybersecurity training environment featuring Kali Linux, isolated targets, SSH networking, terminal exercises, system administration, and hands-on security labs. Designed to build practical skills through realistic simulations and repeatable challenges.

## Real Linux Command Sandbox

SSH into a real Kali shell. Nothing is simulated: `rm` deletes, `chmod 000` locks, `ssh` opens a real connection to a second machine. Break it, then reset it.

```
Windows 11 → Docker Desktop
 └─ copycat (compose project)
     ├─ copycat-kali    SSH :2222 (127.0.0.1 only) · bash · sudo · apt · man · cron · rsyslog · seeded /home/copycat
     └─ copycat-target  Alpine · sshd · HTTP :80 · user "student" · reachable only from copycat-kali
```

## Use it

```powershell
copycat-start             # build + start (first build downloads Kali; a few minutes)
copycat-ssh               # same as: ssh copycat@127.0.0.1 -p 2222   (password: copycat)
copycat-stop              # pause; your changes are kept
copycat-reset             # blow it all away and rebuild from the image
copycat-reset -Rebuild    # same, but rebuild images from scratch too
copycat-selftest          # check everything works (needs only Docker + Git Bash/WSL)
```
These are launchers in `bin\` (added to your user PATH). They call the scripts in `scripts\`, which you can also run directly (`.\scripts\copycat-start.ps1`; Linux/WSL/macOS use the `.sh` versions).
`copycat-stop` keeps whatever you did inside the lab; only `copycat-reset` wipes it. After `copycat-reset -Rebuild`, ssh may warn that the host key changed: run `ssh-keygen -R "[127.0.0.1]:2222"` once.

| Machine | Login | Notes |
|---|---|---|
| copycat-kali | `copycat` / `copycat` | non-root, in `sudo` (password required). Others: `alex`, `sam`, `jordan` / `password` |
| copycat-target | `student` / `student` | from kali: `ssh student@copycat-target`, `curl http://copycat-target` |

Inside: `copycat-help`, `copycat-labs` (progress list), `copycat-done NN` (mark a lab finished), `copysay` (a tip). Exercises are plain READMEs in `~/labs/NN-name/`: 20 labs, each with steps, a self-check and a challenge.

## Safety model
No volumes/host mounts, no Docker socket, not privileged, no host network, default capabilities, pid/memory/CPU limits, SSH bound to loopback only. Reset touches only the `copycat` compose project, so other containers (kali-practice, Juice Shop, …) are never affected.

## Honest limits (by design: we don't fake Linux)
- No systemd, so `hostnamectl`/`systemctl` aren't meaningful. `service ssh|cron|rsyslog status` is real.
- `lspci`, `lsusb`, `dmidecode`, `mount`, `iptables`, `ufw` are not in v1 (hardware / extra capabilities). They belong in a later isolated `copycat-system` container.
- `pacman`, `rpm`, `dnf` need their own distros (later `copycat-arch`, `copycat-rpm`).
- Container is online (apt/wget to the Internet work). An isolated mode is a later phase: Docker can't publish SSH to the host from a network-less container, so it needs a small gateway design.
- Host SSH keys are baked in at build, so resets don't trigger "host key changed" warnings; `-Rebuild` will.

## v1 checklist
SSH in as non-root · banner · sudo · apt · man · shortcuts · seeded files · find/grep · permissions · users/groups · processes · logs · tar/zip · target resolves · ping · ssh/scp/sftp/rsync · curl/wget · destroy and reset · no mounts · no docker.sock.

## Layout
`compose.yaml` · `kali/` (Dockerfile, entrypoint, motd, helper commands) · `target/` (Dockerfile, www/, home/) · `seed/generate.sh` (builds the training tree at image build) · `labs/` (exercise READMEs, copied into the image) · `scripts/`
