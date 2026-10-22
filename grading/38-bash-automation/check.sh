#!/bin/bash
. /usr/local/lib/copycat/grade.sh
d="$HOME/labs/38-bash-automation"
s="$d/logsummary.sh"
cd "$d" 2>/dev/null || true

# run the student's script, capturing stdout, stderr and the exit code
run() { out=$(bash "$s" "$@" 2>"$d/.err"); rc=$?; err=$(cat "$d/.err"); rm -f "$d/.err"; }
t_usage()  { run; [ "$rc" -eq 2 ] && printf '%s' "$err" | grep -qi '^usage'; }
t_one()    { run logs/app1.log; [ "$rc" -eq 0 ] && [ "$out" = "logs/app1.log: ERROR=3 WARN=2" ]; }
t_two()    { run logs/app1.log logs/app2.log; [ "$rc" -eq 0 ] && [ "$(printf '%s\n' "$out" | sed -n 2p)" = "logs/app2.log: ERROR=0 WARN=1" ]; }
t_miss()   { run logs/app1.log logs/nope.log logs/app2.log; [ "$rc" -eq 1 ] && printf '%s' "$out" | grep -q 'logs/app2.log: ERROR=0 WARN=1' && [ -n "$err" ]; }
t_func()   { grep -Eq '^[[:space:]]*(function[[:space:]]+)?[A-Za-z_][A-Za-z0-9_]*[[:space:]]*\(\)' "$s"; }
t_loop()   { grep -Eq '^[[:space:]]*(for|while|until)[[:space:]]' "$s"; }

grade_start 38 "BASH AUTOMATION"

grade_section "Usage and errors"
item "logsummary.sh must exist and be executable (run copycat-setup 38)" test -x "$s"
item "no arguments: print 'usage...' to stderr and exit 2" t_usage
item "a missing file: message on stderr, continue, exit 1 at the end" t_miss

grade_section "Output"
item "one file: 'logs/app1.log: ERROR=3 WARN=2' and exit 0" t_one
item "two files: one line per file in order, exit 0" t_two

grade_section "Structure"
item "uses at least one function" t_func
item "uses a loop (for/while)" t_loop

grade_finish
