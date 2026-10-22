#!/bin/bash
rm -f /home/copycat/.ssh/id_lab29*
runuser -u copycat -- ssh-keygen -q -t ed25519 -f /home/copycat/.ssh/id_lab29 -N '' </dev/null
runuser -u copycat -- sshpass -p student ssh-copy-id -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
  -i /home/copycat/.ssh/id_lab29.pub student@copycat-target </dev/null
