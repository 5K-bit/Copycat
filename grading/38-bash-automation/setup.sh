#!/bin/bash
# Lab 38: sample logs and an empty script skeleton.
d=/home/copycat/labs/38-bash-automation
rm -rf "$d"
mkdir -p "$d/logs"
cat > "$d/logs/app1.log" <<'EOF'
2026-10-22 09:00:01 INFO start
2026-10-22 09:00:05 WARN disk at 81%
2026-10-22 09:01:10 ERROR cannot reach db
2026-10-22 09:01:15 ERROR retry failed
2026-10-22 09:02:00 INFO recovered
2026-10-22 09:03:00 WARN slow query
2026-10-22 09:04:00 ERROR timeout
EOF
cat > "$d/logs/app2.log" <<'EOF'
2026-10-22 10:00:00 INFO start
2026-10-22 10:00:30 INFO ok
2026-10-22 10:01:00 WARN cache cold
EOF
printf '#!/bin/bash\n# TODO: write logsummary.sh (see the lab README)\n' > "$d/logsummary.sh"
chmod 755 "$d/logsummary.sh"
chown -R copycat:copycat "$d"
cat <<'EOF'
Challenge ready: ~/labs/38-bash-automation
Write logsummary.sh as described in the README, then run:  copycat-check 38
EOF
