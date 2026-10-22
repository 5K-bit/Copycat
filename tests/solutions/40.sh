#!/bin/bash
d=/home/copycat/labs/40-system-recovery/app
chmod 755 "$d/bin/run.sh"
ln -sfn releases/v1 "$d/current"
cp -p "$d/config/app.conf.good" "$d/config/app.conf"
chown copycat:copycat "$d/data" "$d/config/app.conf"
chown -h copycat:copycat "$d/current"
