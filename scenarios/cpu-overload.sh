# shellcheck shell=bash disable=SC2034
S_QUESTION="Which process is exhausting resources?"
S_TITLE="CPU OVERLOAD"

s_symptom() {
  cat <<'EOF'
The machine feels sluggish and the fan noise says something is working hard.
Find the process that is eating CPU and stop it. Leave everything else running.
EOF
}

s_break() {
  pkill -f '^reportgen ' 2>/dev/null
  runuser -u jordan -- setsid nohup bash -c 'exec -a reportgen bash -c "while :; do :; done"' >/dev/null 2>&1 &
  sleep 1
  true
}

s_reset() { pkill -f '^reportgen ' 2>/dev/null; true; }
s_fix() { pkill -f '^reportgen ' 2>/dev/null; true; }

no_reportgen() { ! ps -eo args= | grep -q '^reportgen '; }
jordan_idle() { ! ps -eo user=,pcpu=,args= | awk '$1 == "jordan" && $2 > 50 { found = 1 } END { exit !found }'; }

s_verify() {
  grade_section "Culprit stopped"
  item "no process named reportgen is left" no_reportgen
  item "nothing owned by jordan is using more than 50% CPU" jordan_idle
  grade_section "Nothing else harmed"
  item "busywork.sh (a normal background job) is still running" pgrep -f busywork
  item "sshd is still running" pgrep -x sshd
}

s_hint1() { echo "Hint 1: top (press q to quit) or ps aux --sort=-pcpu | head  show who is using the CPU."; }
s_hint2() { echo "Hint 2: note the PID and owner. It belongs to another user, so you will need sudo kill PID."; }
s_reveal() {
  cat <<'EOF'
Cause: a process called "reportgen", owned by jordan, spins in an endless loop and uses a full core.
Find:  ps aux --sort=-pcpu | head -5      (or top, sorted by %CPU)
Fix:   sudo kill <PID>    (kill -9 only if a plain kill is ignored)
Method: look at the numbers first, then who owns the process, then stop that one process only.
EOF
}
