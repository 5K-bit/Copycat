#!/bin/bash
# Lab 37: a config repo with three commits; the second one breaks the config.
d=/home/copycat/labs/37-git-fundamentals/config-repo
rm -rf /home/copycat/labs/37-git-fundamentals
mkdir -p "$d"
cd "$d" || exit 1
git init -q .
git config user.name "Alex Dev"
git config user.email "alex@copycat.invalid"
printf 'name=shop\ntimeout=30\nretries=3\n' > app.conf
git add app.conf && git commit -qm "Initial config"
sed -i 's/^timeout=30/timeout=0/' app.conf
git commit -qam "Tune timeout for speed"
printf '# managed in git\n' >> app.conf
git commit -qam "Add a comment"
chown -R copycat:copycat /home/copycat/labs/37-git-fundamentals
runuser -u copycat -- git -C "$d" config user.name "Copycat Student"
runuser -u copycat -- git -C "$d" config user.email "student@copycat.invalid"
cat <<'EOF'
Challenge ready: ~/labs/37-git-fundamentals/config-repo
The app hangs since timeout was changed. Find the bad commit and restore timeout=30 without rewriting history.
Then run:  copycat-check 37
EOF
