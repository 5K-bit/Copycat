#!/usr/bin/env bash
# Verifies the lab against the running containers. Needs only Docker on the host
# (no sshpass): the SSH checks run from inside copycat-kali. Run after copycat-start.
cd "$(dirname "$0")/.." || exit 1
pass=0; fail=0
check(){ local d=$1; shift; if "$@" >/dev/null 2>&1; then echo "  ok   $d"; pass=$((pass+1)); else echo "  FAIL $d"; fail=$((fail+1)); fi; }
K="docker exec -u copycat copycat-kali"
SSHO="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
echo "Copycat self-test"
check "containers are running"         bash -c "[ \"\$(docker ps -q --filter name=copycat- | wc -l)\" -ge 2 ]"
check "SSH into copycat-kali as non-root" $K bash -c "sshpass -p copycat ssh $SSHO copycat@localhost 'test \$(id -u) -ne 0'"
check "banner shown on login"          $K bash -c "grep -q 'COPYCAT COMMAND SANDBOX' /etc/motd && grep -q '^session.*pam_motd' /etc/pam.d/sshd"
check "login panel runs"               $K bash -c "copycat-panel | grep -q 'labs'"
check "published on 127.0.0.1:2222 only" bash -c "docker port copycat-kali 22 | grep -q '^127.0.0.1:2222'"
check "sudo works"                     $K bash -c "echo copycat | sudo -S -p '' true"
check "seed files exist"               $K test -f /home/copycat/test-data/numbers.txt -a -f /home/copycat/test-data/secret.txt
check "locate works immediately"       $K bash -c "locate numbers.txt | grep -q numbers.txt"
check "man pages work"                 $K bash -c "man ls | head -1 | grep -q LS"
check "users and groups exist"         $K bash -c "id alex | grep -q developers && getent group students admins"
check "processes to inspect exist"     $K pgrep -f busywork
check "services running (ssh, cron, rsyslog)" $K bash -c "pgrep -x sshd && pgrep -x cron && pgrep -x rsyslogd"
check "auth log has data"              docker exec copycat-kali bash -c "test -s /var/log/auth.log"
check "tar/gzip/zip work"              $K bash -c "cd /tmp && tar czf t.tgz -C ~/labs/12-archives to-compress && zip -qr t.zip ~/labs/12-archives/to-compress"
check "copycat helpers installed"      $K bash -c "command -v copycat-help copycat-labs copycat-done copysay"
check "copycat-labs lists the labs"    $K bash -c "copycat-labs | grep -q 01"
check "copycat-done records progress"  $K bash -c 'f=~/.copycat-progress; had=0; [ -e $f ] && cp $f /tmp/p.bak && had=1; copycat-done 01 && grep -q 01-core $f; r=$?; if [ $had = 1 ]; then cp /tmp/p.bak $f; else rm -f $f; fi; exit $r'
check "target resolves by hostname"    $K getent hosts copycat-target
check "ping target"                    $K ping -c1 -W2 copycat-target
check "curl target"                    $K curl -fsS http://copycat-target/files/numbers.txt
check "wget target"                    $K wget -q -O /tmp/n.txt http://copycat-target/files/numbers.txt
check "ssh to target"                  $K sshpass -p student ssh $SSHO student@copycat-target hostname
check "scp to target"                  $K bash -c "sshpass -p student scp $SSHO ~/test-data/numbers.txt student@copycat-target:/home/student/"
check "sftp to target"                 $K bash -c "printf 'ls\nbye\n' | sshpass -p student sftp $SSHO student@copycat-target"
check "rsync to target"                $K bash -c "sshpass -p student rsync -a -e 'ssh $SSHO' ~/Documents/ student@copycat-target:/home/student/docs/"
check "no host mounts"                 bash -c "[ -z \"\$(docker inspect -f '{{range .Mounts}}{{.Source}}{{end}}' copycat-kali copycat-target)\" ]"
check "docker.sock not exposed"        bash -c "! docker exec copycat-kali test -S /var/run/docker.sock"
check "not privileged"                 bash -c "[ \"\$(docker inspect -f '{{.HostConfig.Privileged}}' copycat-kali)\" = false ]"
echo "$pass passed, $fail failed"; [ "$fail" -eq 0 ]
