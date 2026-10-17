# Contributing

Thanks for your interest in Copycat.

## Ways to help

- Report bugs or confusing lab steps via an issue.
- Suggest or write new labs (see `labs/` for the format: steps, a self-check, a challenge).
- Improve scripts, docs, or the Windows/macOS/Linux launchers.

## Development

```bash
./scripts/copycat-start.sh      # build and start
./scripts/copycat-selftest.sh   # must pass before you open a PR
./scripts/copycat-reset.sh      # clean slate
```

## Guidelines

- Keep the "nothing is simulated" principle: labs use real commands on real systems.
- Preserve the safety model (no host mounts, no Docker socket, no privileged mode, loopback-only SSH).
- Shell scripts must stay LF and pass `shellcheck`.
- Each lab README should include steps, a self-check and a challenge, and an approximate time.
- Use clear, descriptive commit messages and keep pull requests focused.
