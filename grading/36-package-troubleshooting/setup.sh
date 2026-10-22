#!/bin/bash
# Lab 36: leave cc-widget installed without its dependency cc-lib.
echo 'deb [trusted=yes] file:/srv/localrepo ./' > /etc/apt/sources.list.d/lab36.list
# Index only the offline repo (no network).
apt-get update -o Dir::Etc::sourcelist=/etc/apt/sources.list.d/lab36.list -o Dir::Etc::sourceparts=/dev/null >/dev/null 2>&1
dpkg --remove --force-depends cc-widget cc-lib >/dev/null 2>&1
dpkg -i --force-depends /srv/localrepo/cc-widget_1.0_all.deb >/dev/null 2>&1
cat <<'EOF'
Challenge ready: cc-widget is installed but its dependency is missing.
Look: sudo dpkg --audit ; dpkg -s cc-widget ; sudo apt-get check
Fix it with apt, then run:  copycat-check 36
EOF
