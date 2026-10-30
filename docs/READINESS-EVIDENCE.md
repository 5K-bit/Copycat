# Startup readiness evidence

Question: does `copycat-selftest.sh` fail intermittently when it runs right after `docker compose up -d`
(a readiness race)? Measured with [`scripts/copycat-readiness-repro.sh`](../scripts/copycat-readiness-repro.sh).

Method: for each run, tear the stack down (`down -v`), start it, run the full selftest, record the result.
Images were built once beforehand. Host: Windows 11 with Docker Desktop (Docker 29.7.2), run from Git Bash.

| Phase | Commit | Start mode | Runs | Passed | Failed |
|---|---|---|---|---|---|
| Before | `6fd1fa0` | `up -d`, selftest started immediately | 20 | 20 | 0 |
| After | `24f5e35` | `up -d --wait` (compose healthchecks), then selftest | 20 | 20 | 0 |

Measured on 2026-10-29. Each run took about 150 seconds, almost all of it the selftest itself.

## What this shows

- No readiness race was observed in 20 immediate-start runs. This does not prove one cannot happen: it is one
  machine, one Docker version, and 20 samples.
- The confirmed gap was different: CI ran `docker compose build` but never started the containers, so the
  selftest (84 checks of the running environment) was not exercised by CI at all.

## What changed because of it

- CI now has a `selftest` job: start the stack with `--wait`, run `copycat-selftest.sh`, upload `ps`, container
  logs and health state on failure, and always run `down -v`.
- Compose healthchecks now describe real readiness (kali: sshd, cron, rsyslog and the seeded busywork process;
  target: sshd and HTTP), and kali waits for target to be healthy. This makes `--wait` meaningful. It was not
  needed to make the 20 runs above pass.

## Reproduce

```bash
scripts/copycat-readiness-repro.sh -n 20 -y                 # selftest immediately after `up -d`
scripts/copycat-readiness-repro.sh -n 20 -y --wait-healthy  # selftest after `up -d --wait`
```

Each run writes `SUMMARY.md` and `summary.csv`, plus logs for any failing run, under `readiness-results/`.
The script destroys and recreates the copycat containers.
