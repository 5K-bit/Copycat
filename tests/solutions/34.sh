#!/bin/bash
d=/home/copycat/labs/34-backup-recovery
cd "$d" || exit 1
tar -xzf backup/site-lastnight.tar.gz site/settings.conf
tar -czf backup/site-restored.tar.gz site
chown -R copycat:copycat "$d"
