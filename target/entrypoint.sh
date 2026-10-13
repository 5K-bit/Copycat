#!/bin/bash
# Real sshd + real HTTP server (busybox httpd). That's the whole machine.
httpd -p 80 -h /var/www
echo "copycat-target ready"
exec /usr/sbin/sshd -D -e
