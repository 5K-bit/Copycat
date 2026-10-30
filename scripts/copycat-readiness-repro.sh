#!/usr/bin/env bash
# Reproduce (or rule out) a startup readiness race.
#
# For each run: tear the stack down, `docker compose up -d`, then run
# copycat-selftest.sh immediately (no wait). Records pass/fail, which checks
# failed, and container logs for failing runs, then prints a verdict.
#
#   scripts/copycat-readiness-repro.sh                 # 20 runs, no wait
#   scripts/copycat-readiness-repro.sh -n 30           # 30 runs
#   scripts/copycat-readiness-repro.sh --wait-ssh      # control: wait for sshd/cron/rsyslog first
#   scripts/copycat-readiness-repro.sh --wait-healthy  # start with `up -d --wait` (compose healthchecks), as CI does
#   scripts/copycat-readiness-repro.sh -o DIR -y       # custom results dir, skip the safety prompt
#
# WARNING: destroys and recreates the copycat containers (same as copycat-reset).
# Exit code: 0 = every run passed, 1 = at least one run failed, 2 = usage/setup error.
cd "$(dirname "$0")/.." || exit 2
export MSYS_NO_PATHCONV=1   # Git Bash must not rewrite /home/... arguments to docker.exe

RUNS=20
WAIT_SSH=0
WAIT_HEALTHY=0
OUT=""
YES=0

usage() {
  sed -n '2,15p' "$0" | sed 's/^# \{0,1\}//'
}

while [ $# -gt 0 ]; do
  case "$1" in
    -n|--runs)  RUNS="${2:-}"; shift 2 || { usage >&2; exit 2; } ;;
    -o|--out)   OUT="${2:-}"; shift 2 || { usage >&2; exit 2; } ;;
    --wait-ssh) WAIT_SSH=1; shift ;;
    --wait-healthy) WAIT_HEALTHY=1; shift ;;
    -y|--yes)   YES=1; shift ;;
    -h|--help)  usage; exit 0 ;;
    *)          echo "unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done

case "$RUNS" in ''|*[!0-9]*|0) echo "--runs must be a positive integer" >&2; exit 2 ;; esac
command -v docker >/dev/null 2>&1 || { echo "docker not found" >&2; exit 2; }
docker info >/dev/null 2>&1 || { echo "docker daemon not reachable" >&2; exit 2; }

if [ "$WAIT_HEALTHY" -eq 1 ]; then mode="wait-healthy"
elif [ "$WAIT_SSH" -eq 1 ]; then mode="wait-ssh"
else mode="nowait"; fi
[ -n "$OUT" ] || OUT="readiness-results/$(date -u +%Y%m%dT%H%M%SZ)-$mode"
mkdir -p "$OUT" || exit 2

if [ "$YES" -ne 1 ] && [ -n "$(docker ps -aq --filter name=copycat-)" ]; then
  echo "Existing copycat containers found. This script destroys them (like copycat-reset)." >&2
  echo "Re-run with --yes to continue." >&2
  exit 2
fi

teardown() { docker compose down -v --remove-orphans >/dev/null 2>&1; }
trap teardown EXIT
trap 'exit 130' INT TERM

# Wait until the services the selftest depends on are running inside copycat-kali.
# Prints seconds waited; returns 1 on timeout.
wait_for_services() {
  local start=$SECONDS
  while [ $((SECONDS - start)) -lt 120 ]; do
    if docker exec copycat-kali bash -c 'pgrep -x sshd && pgrep -x cron && pgrep -x rsyslogd' >/dev/null 2>&1; then
      echo $((SECONDS - start)); return 0
    fi
    sleep 1
  done
  echo $((SECONDS - start)); return 1
}

echo "Building images once (not part of the measured runs)..."
docker compose build >"$OUT/build.log" 2>&1 || { echo "build failed, see $OUT/build.log" >&2; exit 2; }

echo "run,status,seconds,wait_seconds,failed_checks" >"$OUT/summary.csv"
passed=0; failed=0

for i in $(seq 1 "$RUNS"); do
  tag=$(printf '%03d' "$i")
  teardown
  up_args="-d"; [ "$WAIT_HEALTHY" -eq 1 ] && up_args="-d --wait --wait-timeout 180"
  # shellcheck disable=SC2086  # intentional word splitting of the flag list
  if ! docker compose up $up_args >"$OUT/run-$tag.up.log" 2>&1; then
    echo "run $tag: UP-FAILED"
    docker compose logs --no-color >"$OUT/run-$tag.containers.log" 2>&1
    echo "$i,up-failed,0,,\"compose up failed\"" >>"$OUT/summary.csv"
    failed=$((failed + 1)); continue
  fi

  t0=$SECONDS; waited=""
  if [ "$WAIT_SSH" -eq 1 ]; then
    waited=$(wait_for_services) || echo "run $tag: services not ready after ${waited}s"
  fi

  bash scripts/copycat-selftest.sh >"$OUT/run-$tag.selftest.log" 2>&1
  rc=$?
  dur=$((SECONDS - t0))

  if [ "$rc" -eq 0 ]; then
    passed=$((passed + 1))
    echo "run $tag: pass (${dur}s)"
    echo "$i,pass,$dur,$waited,\"\"" >>"$OUT/summary.csv"
  else
    failed=$((failed + 1))
    fails=$(grep '^  FAIL ' "$OUT/run-$tag.selftest.log" | sed 's/^  FAIL //' | paste -sd';' -)
    echo "run $tag: FAIL (${dur}s) -> ${fails:-no FAIL lines; see log}"
    docker compose logs --no-color >"$OUT/run-$tag.containers.log" 2>&1
    docker compose ps -a >"$OUT/run-$tag.ps.txt" 2>&1
    echo "$i,fail,$dur,$waited,\"$fails\"" >>"$OUT/summary.csv"
  fi
done

total=$((passed + failed))
if [ "$failed" -eq 0 ]; then
  verdict="No failures in $total runs. A race was NOT observed (this does not prove one cannot happen)."
elif [ "$passed" -eq 0 ]; then
  verdict="All $total runs failed. Deterministic failure, not a race: fix the failing checks below."
else
  verdict="Intermittent: $failed of $total runs failed. Race candidate; compare against a --wait-ssh run."
fi

{
  echo "# Copycat readiness reproduction"
  echo
  echo "- Date (UTC): $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "- Commit: $(git rev-parse --short HEAD 2>/dev/null || echo unknown)"
  echo "- Mode: $mode (selftest started $(case "$mode" in wait-healthy) echo 'after compose up --wait reported healthy';; wait-ssh) echo 'after sshd/cron/rsyslog were running';; *) echo 'immediately after compose up -d';; esac))"
  echo "- Host: $(uname -srm)"
  echo "- Docker: $(docker version --format '{{.Server.Version}}' 2>/dev/null || echo unknown)"
  echo "- Runs: $total, passed: $passed, failed: $failed"
  echo
  echo "**Verdict:** $verdict"
  echo
  echo "## Failing checks (count across runs)"
  echo
  if ls "$OUT"/run-*.selftest.log >/dev/null 2>&1 && grep -qh '^  FAIL ' "$OUT"/run-*.selftest.log; then
    grep -h '^  FAIL ' "$OUT"/run-*.selftest.log | sed 's/^  FAIL //' | sort | uniq -c | sort -rn | sed 's/^ *\([0-9]*\) \(.*\)$/- \1x \2/'
  else
    echo "None."
  fi
  echo
  echo "Per-run data: summary.csv. Failing runs also have run-NNN.selftest.log, run-NNN.containers.log and run-NNN.ps.txt."
} >"$OUT/SUMMARY.md"

echo
cat "$OUT/SUMMARY.md"
echo
echo "Results saved in $OUT"

[ "$failed" -eq 0 ]
