# Security Policy

Copycat is a training sandbox. It ships deliberately weak, publicly documented credentials (for example `copycat`/`copycat`), so they are **not** vulnerabilities. It is designed to bind only to `127.0.0.1` and must not be exposed to untrusted networks.

## Reporting a vulnerability

If you find a way to escape the container, reach the host, break the loopback-only binding, or otherwise defeat the safety model in the README, please report it privately through GitHub's **Security → Report a vulnerability** on this repository rather than opening a public issue.

Include the steps to reproduce and the Docker version and host OS. Expect an initial response within a few days.
