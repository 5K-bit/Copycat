cat > /home/copycat/labs/38-bash-automation/logsummary.sh <<'SCRIPT'
#!/bin/bash
usage() { echo "usage: $0 FILE..." >&2; exit 2; }
[ $# -ge 1 ] || usage
rc=0
for f in "$@"; do
  if [ ! -r "$f" ]; then echo "cannot read $f" >&2; rc=1; continue; fi
  echo "$f: ERROR=$(grep -c ERROR "$f") WARN=$(grep -c WARN "$f")"
done
exit "$rc"
SCRIPT
chmod 755 /home/copycat/labs/38-bash-automation/logsummary.sh
chown copycat:copycat /home/copycat/labs/38-bash-automation/logsummary.sh
