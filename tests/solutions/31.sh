#!/bin/bash
groupadd interns
useradd -m -s /bin/bash -G students,interns taylor
mkdir -p /srv/interns; chgrp interns /srv/interns; chmod 2770 /srv/interns
chage -M 90 taylor
