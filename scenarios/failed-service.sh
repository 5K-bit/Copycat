# shellcheck shell=bash disable=SC2034
S_QUESTION="Why isn't the application responding?"
S_TITLE="SERVICE DOWN"

s_symptom() {
  cat <<'EOF'
The company app should answer on port 8080, but:   curl http://localhost:8080
fails. It is managed like any other service:       service copycat-app status
Get it running and answering "copycat app ok".
EOF
}

s_break() {
  /etc/init.d/copycat-app stop >/dev/null 2>&1
  printf 'PORT=8080\nLOGDIR=/var/log/copycat-app-logs\n' > /etc/copycat-app.conf   # this folder does not exist
  rm -rf /var/log/copycat-app-logs /var/log/copycat-app.err
  /etc/init.d/copycat-app start >/dev/null 2>&1   # fails, leaving the error behind
  true
}

s_reset() {
  /etc/init.d/copycat-app stop >/dev/null 2>&1
  rm -rf /etc/copycat-app.conf /var/log/copycat-app-logs /var/log/copycat-app /var/log/copycat-app.err
  true
}
s_fix() {
  mkdir -p /var/log/copycat-app-logs
  /etc/init.d/copycat-app start >/dev/null 2>&1
}

s_verify() {
  grade_section "Service state"
  item "service copycat-app status says it is running" service copycat-app status
  grade_section "Application answers"
  item "curl localhost:8080 returns 'copycat app ok'" bash -c "[ \"\$(curl -s -m 5 http://localhost:8080)\" = 'copycat app ok' ]"
  grade_section "Configuration"
  item "the config still sets PORT=8080" grep -qx 'PORT=8080' /etc/copycat-app.conf
}

s_hint1() { echo "Hint 1: ask the service (service copycat-app status), then read the error it leaves: cat /var/log/copycat-app.err"; }
s_hint2() { echo "Hint 2: the app cannot write to the log folder named in /etc/copycat-app.conf. Does that folder exist? Fix, then: sudo service copycat-app start"; }
s_reveal() {
  cat <<'EOF'
Cause: /etc/copycat-app.conf points LOGDIR at /var/log/copycat-app-logs, which does not exist, so the app
       exits at start-up. Its complaint is in /var/log/copycat-app.err.
Fix:   sudo mkdir -p /var/log/copycat-app-logs ; sudo service copycat-app start
       (or change LOGDIR to a folder that exists, then start it)
Method: status -> logs -> config -> fix -> restart -> test with curl.
EOF
}
