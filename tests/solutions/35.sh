d=/home/copycat/labs/35-scheduled-automation
printf '#!/bin/bash\necho "$(date +%%F_%%T) beat" >> /home/copycat/labs/35-scheduled-automation/heartbeat.log\n' > "$d/heartbeat.sh"
chmod 755 "$d/heartbeat.sh"; chown copycat:copycat "$d/heartbeat.sh"
runuser -u copycat -- "$d/heartbeat.sh"
echo '* * * * * /home/copycat/labs/35-scheduled-automation/heartbeat.sh' | runuser -u copycat -- crontab -
sleep 75
