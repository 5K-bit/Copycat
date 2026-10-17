<div align="center">

```
    /\_/\            /\_/\
   ( o.o )  ══════▶ ( o.o )
    > ^ <            > ^ <

 ██████╗ ██████╗ ██████╗ ██╗   ██╗ ██████╗ █████╗ ████████╗
██╔════╝██╔═══██╗██╔══██╗╚██╗ ██╔╝██╔════╝██╔══██╗╚══██╔══╝
██║     ██║   ██║██████╔╝ ╚████╔╝ ██║     ███████║   ██║
██║     ██║   ██║██╔═══╝   ╚██╔╝  ██║     ██╔══██║   ██║
╚██████╗╚██████╔╝██║        ██║   ╚██████╗██║  ██║   ██║
 ╚═════╝ ╚═════╝ ╚═╝        ╚═╝    ╚═════╝╚═╝  ╚═╝   ╚═╝
```

**A real Linux command sandbox. SSH in, break things, reset in one command.**

[![CI](https://github.com/5K-bit/Copycat/actions/workflows/ci.yml/badge.svg)](https://github.com/5K-bit/Copycat/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![Docker](https://img.shields.io/badge/docker-compose-2496ED?logo=docker&logoColor=white)
![Kali Linux](https://img.shields.io/badge/kali-rolling-557C94?logo=kalilinux&logoColor=white)
![Shell](https://img.shields.io/badge/shell-bash-4EAA25?logo=gnubash&logoColor=white)
![Labs](https://img.shields.io/badge/labs-20-ff69b4)

</div>

---

## Overview

Copycat is a Docker-based Linux and cybersecurity training environment. You SSH into a **real Kali Linux shell**; nothing is simulated. `rm` deletes, `chmod 000` locks you out, and `ssh` opens a genuine connection to a second machine on an isolated network. When you've made a mess, one command rebuilds a clean environment.

It's built for learning the way sysadmins and security engineers actually learn: by running real commands against real systems, safely, and repeating until it's muscle memory.

## Features

- **Real shell, real consequences.** Kali Linux with `bash`, `sudo`, `apt`, `man`, `cron`, `rsyslog` and a seeded home directory to explore.
- **Two-machine network.** `copycat-kali` plus an Alpine `copycat-target` running sshd and HTTP, reachable only from the Kali box. Practice `ssh`, `scp`, `rsync`, `curl` and recon against a live host.
- **20 guided labs.** Each has steps, a self-check and a challenge, with progress tracked in-shell (`copycat-labs`, `copycat-done NN`).
- **Safe by construction.** No volumes, no host mounts, no Docker socket, not privileged, SSH bound to loopback only. See [Safety model](#safety-model).
- **One-command lifecycle.** `copycat-start`, `copycat-stop`, `copycat-reset`, plus a `copycat-selftest` that verifies the whole environment.
- **Cross-platform.** PowerShell launchers for Windows, shell scripts for Linux, macOS and WSL.

## Architecture

```
Host (Windows / Linux / macOS) → Docker
 └─ copycat (compose project)
     ├─ copycat-kali    SSH :2222 (127.0.0.1 only) · bash · sudo · apt · man · cron · rsyslog
     └─ copycat-target  Alpine · sshd · HTTP :80 · user "student" · reachable only from copycat-kali
```

More detail in [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Quick start

**Requirements:** Docker (Desktop on Windows/macOS) and Git.

```powershell
copycat-start             # build + start (first build downloads Kali; a few minutes)
copycat-ssh               # same as: ssh copycat@127.0.0.1 -p 2222   (password: copycat)
copycat-stop              # pause; your changes are kept
copycat-reset             # blow it all away and rebuild from the image
copycat-reset -Rebuild    # same, but rebuild images from scratch too
copycat-selftest          # verify the environment (needs only Docker + Git Bash/WSL)
```

The launchers live in `bin\` and call the scripts in `scripts\`, which you can also run directly (`.\scripts\copycat-start.ps1`; Linux, WSL and macOS use the `.sh` versions).

`copycat-stop` keeps whatever you did inside the lab; only `copycat-reset` wipes it. After `copycat-reset -Rebuild`, ssh may warn that the host key changed: run `ssh-keygen -R "[127.0.0.1]:2222"` once.

| Machine | Login | Notes |
|---|---|---|
| `copycat-kali` | `copycat` / `copycat` | non-root, in `sudo` (password required). Others: `alex`, `sam`, `jordan` / `password` |
| `copycat-target` | `student` / `student` | from Kali: `ssh student@copycat-target`, `curl http://copycat-target` |

Inside the sandbox: `copycat-help`, `copycat-labs` (progress list), `copycat-done NN` (mark a lab finished), `copysay` (a tip from the cat).

> These credentials are deliberately simple training defaults for a sandbox bound to `127.0.0.1`. Don't reuse them anywhere real.

## Labs

Exercises are plain READMEs in `~/labs/NN-name/`, about 5 hours in total.

| # | Lab | # | Lab |
|---|---|---|---|
| 01 | Core commands | 11 | File transfer |
| 02 | Navigation | 12 | Archives and compression |
| 03 | Files | 13 | Disk usage |
| 04 | Searching | 14 | Logs |
| 05 | Text processing | 15 | Package management (APT) |
| 06 | Permissions | 16 | Shell and shortcuts |
| 07 | Users and groups | 17 | Pipes and redirection |
| 08 | Processes | 18 | Scheduling with cron |
| 09 | Networking | 19 | Shell scripting |
| 10 | SSH | 20 | Text editors |

## Safety model

No volumes or host mounts, no Docker socket, not privileged, no host network, default capabilities, pid/memory/CPU limits, SSH bound to loopback only. Reset touches only the `copycat` compose project, so your other containers are never affected. To report a security issue, see [SECURITY.md](SECURITY.md).

## Honest limits

Copycat doesn't fake Linux, so some things are out of scope by design:

- No systemd, so `hostnamectl`/`systemctl` aren't meaningful. `service ssh|cron|rsyslog status` is real.
- `lspci`, `lsusb`, `dmidecode`, `mount`, `iptables`, `ufw` aren't in v1 (hardware / extra capabilities). They belong in a later isolated `copycat-system` container.
- `pacman`, `rpm`, `dnf` need their own distros (planned `copycat-arch`, `copycat-rpm`).
- The container is online (apt/wget to the Internet work). An isolated mode is a later phase: Docker can't publish SSH to the host from a network-less container, so it needs a small gateway design.
- Host SSH keys are baked in at build, so resets don't trigger "host key changed" warnings; `-Rebuild` will.

## Roadmap

- [ ] `copycat-system` container for hardware and firewall tooling
- [ ] `copycat-arch` and `copycat-rpm` for other package managers
- [ ] Isolated (offline) mode via a small gateway
- [ ] Security-focused labs (recon, web, privilege escalation) against `copycat-target`

## Repository layout

| Path | Purpose |
|---|---|
| `compose.yaml` | the two-machine environment |
| `kali/` | Dockerfile, entrypoint, banner, helper commands |
| `target/` | Alpine target: Dockerfile, `www/`, `home/` |
| `seed/generate.sh` | builds the training file tree at image build time |
| `labs/` | exercise READMEs, copied into the image |
| `scripts/`, `bin/` | lifecycle scripts and Windows launchers |

## Contributing

Issues and pull requests are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE) © 5K-bit
