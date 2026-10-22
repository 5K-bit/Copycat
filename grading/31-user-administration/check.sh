#!/bin/bash
. /usr/local/lib/copycat/grade.sh

grade_start 31 "USER ADMINISTRATION"

grade_section "Account"
item "user taylor must exist (useradd)" getent passwd taylor
item "taylor needs the home directory /home/taylor" test -d /home/taylor
item "taylor's shell must be /bin/bash" test "$(getent passwd taylor | cut -d: -f7)" = /bin/bash

grade_section "Group membership"
item "taylor must be in the group students" bash -c "id -nG taylor 2>/dev/null | tr ' ' '\n' | grep -qx students"
item "taylor must be in the new group interns" bash -c "id -nG taylor 2>/dev/null | tr ' ' '\n' | grep -qx interns"
item "taylor must NOT be in sudo" bash -c "! id -nG taylor 2>/dev/null | tr ' ' '\n' | grep -qx sudo"
item "sam must NOT be in interns" bash -c "! id -nG sam | tr ' ' '\n' | grep -qx interns"

grade_section "Access policy"
item "/srv/interns must exist with group interns" test "$(stat -c %G /srv/interns 2>/dev/null)" = interns
item "/srv/interns must be mode 2770" test "$(stat -c %a /srv/interns 2>/dev/null)" = 2770
item "taylor's password must expire after 90 days (chage -M 90)" bash -c "sudo -n /usr/bin/chage -l taylor | grep -i 'maximum' | grep -q '90'"

grade_finish
