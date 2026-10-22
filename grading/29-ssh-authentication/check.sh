#!/bin/bash
. /usr/local/lib/copycat/grade.sh
k="$HOME/.ssh/id_lab29"

grade_start 29 "SSH AUTHENTICATION"

grade_section "Key pair"
item "the key files .ssh/id_lab29 and id_lab29.pub must exist in your home folder (ssh-keygen -f)" test -f "$k" -a -f "$k.pub"
item "the key must be ed25519 or RSA of at least 3072 bits" bash -c "ssh-keygen -l -f '$k.pub' | grep -Eq '(ED25519|RSA)' && ssh-keygen -l -f '$k.pub' | awk '{ if (\$4 ~ /ED25519/ || \$1 >= 3072) ok=1 } END { exit !ok }'"

grade_section "Key permissions"
item "the private key must be readable only by you (mode 600)" test "$(stat -c %a "$k" 2>/dev/null)" = 600

grade_section "Key-based login"
item "login to student@copycat-target works with the key and no password" \
  ssh -i "$k" -o IdentitiesOnly=yes -o BatchMode=yes -o PasswordAuthentication=no \
      -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=6 student@copycat-target true

grade_finish
