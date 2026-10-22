#!/bin/bash
# Lab 40: four faults in a miniature application tree.
d=/home/copycat/labs/40-system-recovery/app
rm -rf /home/copycat/labs/40-system-recovery
mkdir -p "$d/bin" "$d/releases/v0" "$d/releases/v1" "$d/config" "$d/data"
echo "version=v0" > "$d/releases/v0/VERSION"
echo "version=v1" > "$d/releases/v1/VERSION"
cat > "$d/bin/run.sh" <<'EOF'
#!/bin/bash
here=$(cd "$(dirname "$0")/.." && pwd)
[ -s "$here/config/app.conf" ] || { echo "config missing or empty: $here/config/app.conf" >&2; exit 1; }
ver=$(sed -n 's/^version=//p' "$here/current/VERSION" 2>/dev/null)
[ -n "$ver" ] || { echo "no release: $here/current does not point at a release" >&2; exit 1; }
touch "$here/data/.write-test" 2>/dev/null || { echo "cannot write to $here/data" >&2; exit 1; }
rm -f "$here/data/.write-test"
echo "app running $ver"
EOF
printf 'mode=production\nthreads=4\n' > "$d/config/app.conf.good"
: > "$d/config/app.conf"
ln -s releases/v9 "$d/current"
chown -R copycat:copycat /home/copycat/labs/40-system-recovery
chown -h copycat:copycat "$d/current"
chown root:root "$d/data"
chmod 644 "$d/bin/run.sh"
cat <<'EOF'
Challenge ready: ~/labs/40-system-recovery/app
Run ./bin/run.sh, read the errors, repair the damage (no deleting!) until it prints "app running v1".
Then run:  copycat-check 40
EOF
