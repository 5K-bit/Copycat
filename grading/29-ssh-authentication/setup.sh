#!/bin/bash
# Lab 29: start from a clean slate (no lab29 key locally or on the target).
rm -f /home/copycat/.ssh/id_lab29 /home/copycat/.ssh/id_lab29.pub
sshpass -p student ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=5 \
  student@copycat-target 'if [ -f ~/.ssh/authorized_keys ]; then grep -v "lab29\|copycat@copycat-kali" ~/.ssh/authorized_keys > ~/.ssh/ak.new; cat ~/.ssh/ak.new > ~/.ssh/authorized_keys; rm -f ~/.ssh/ak.new; fi' 2>/dev/null
cat <<'EOF'
Challenge ready. Set up key-based login to student@copycat-target with a new ed25519 key named id_lab29
(see the lab README for the commands). Then run:  copycat-check 29
EOF
