#!/bin/bash
. /usr/local/lib/copycat/grade.sh
status() { dpkg-query -W -f='${Status}' "$1" 2>/dev/null; }

grade_start 36 "PACKAGE TROUBLESHOOTING"

grade_section "Dependency"
item "cc-lib must be installed (run copycat-setup 36 first if nothing is wrong)" bash -c "[ \"\$(dpkg-query -W -f='\${Status}' cc-lib 2>/dev/null)\" = 'install ok installed' ]"
item "cc-lib must be version 2.0 or newer" dpkg --compare-versions "$(dpkg-query -W -f='${Version}' cc-lib 2>/dev/null || echo 0)" ge 2.0

grade_section "Package state"
item "cc-widget must be fully installed (not half-configured)" bash -c "[ \"\$(dpkg-query -W -f='\${Status}' cc-widget 2>/dev/null)\" = 'install ok installed' ]"
item "dpkg --audit must report nothing (no half-installed packages)" bash -c '[ -z "$(dpkg --audit 2>&1)" ]'

grade_section "It works"
item "running cc-widget prints 'widget ok'" bash -c "[ \"\$(cc-widget 2>/dev/null)\" = 'widget ok' ]"

grade_finish
