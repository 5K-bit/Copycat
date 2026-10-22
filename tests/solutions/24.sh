#!/bin/bash
# Solution for lab 24 (run as root by the self-test only).
d=/srv/lab24
chgrp developers "$d/shared"; chmod 3770 "$d/shared"
chmod 640 "$d/shared/handbook.txt"
setfacl -m u:sam:r "$d/shared/handbook.txt"
setfacl -m u:sam:x "$d/shared"
chmod 755 "$d/tools/report"
