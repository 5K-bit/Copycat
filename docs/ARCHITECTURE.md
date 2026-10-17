# Architecture

Copycat is a two-container Docker Compose project. The design goal is **realism with containment**: learners get genuine Linux behaviour, while the blast radius of any command stays inside the project.

```
            host 127.0.0.1:2222
                    │  (only published port)
        ┌───────────▼───────────┐        private compose network
        │     copycat-kali      │ ──────────────────────────────┐
        │ Kali · sshd · sudo    │                               │
        │ apt · cron · rsyslog  │                    ┌──────────▼─────────┐
        └───────────────────────┘                    │   copycat-target   │
                                                     │ Alpine · sshd · :80│
                                                     └────────────────────┘
```

## Components

| Component | Source | Role |
|---|---|---|
| `copycat-kali` | `kali/` | The learner's shell. Login banner, helper commands (`copycat-*`, `copysay`), seeded home directory and labs. |
| `copycat-target` | `target/` | A second host to practise ssh, file transfer and HTTP against. Not reachable from the host. |
| Seed tree | `seed/generate.sh` | Generates the training filesystem at image build so every reset starts identical. |
| Labs | `labs/` | 20 README exercises copied into `~/labs/` at build. |
| Lifecycle scripts | `scripts/`, `bin/` | `start`, `stop`, `reset`, `ssh`, `selftest` for PowerShell and POSIX shells. |

## Lifecycle

- **start** builds images if needed and brings the project up.
- **stop** pauses containers; filesystem changes persist.
- **reset** removes the `copycat` project's containers and recreates them from the image. `-Rebuild` also rebuilds images.
- **selftest** checks login, sudo, apt, cron, name resolution, ssh between machines, and the safety properties below.

## Banner

`kali/motd` holds the plain-text art. `kali/bin/copycat` colours it line by line with ANSI 256-colour escapes (pink mascot, cyan-to-blue gradient wordmark) and respects `NO_COLOR` and non-terminal output. The Dockerfile bakes the coloured version into `/etc/motd` at build time; the selftest asserts the banner is shown on login.

## Safety properties

Verified by `copycat-selftest`: no volumes or host mounts, no Docker socket, not privileged, no host networking, default capabilities, pid/memory/CPU limits, SSH published on loopback only. Reset is scoped to the `copycat` compose project.
