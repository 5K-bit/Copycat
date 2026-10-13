#!/bin/bash
# Builds the training filesystem. Usage: generate.sh <home-dir> <labs-src-dir>
# Runs once at image build time as root. Deterministic: same image, same files.
set -euo pipefail
H=${1:?home}; LABS_SRC=${2:?labs}

mkdir -p "$H"/{labs,Documents,Downloads,Projects,logs,scripts,hidden,test-data}
cp -r "$LABS_SRC"/. "$H/labs/"

# ---------- test-data ----------
cd "$H/test-data"
printf '10\n25\n3\n100\n42\n17\n8\n' > numbers.txt
printf 'alice\nbob\ncharlie\ndave\neve\nfrank\ngrace\nheidi\nivan\njudy\n' > names.txt
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\nk\nl\nm\nn\no\np\nq\nr\ns\nt\nu\nv\nw\nx\ny\nz\n' > alphabet.txt
cat > employees.csv <<'CSV'
id,name,department,salary,city
1,Alice Archer,Engineering,85000,Boston
2,Bob Baker,Sales,62000,Chicago
3,Charlie Chen,Engineering,91000,Boston
4,Dana Diaz,HR,58000,Denver
5,Evan Ellis,Sales,64000,Chicago
6,Fay Foster,Engineering,88000,Austin
7,Gus Green,Support,47000,Denver
8,Hana Hill,HR,59000,Boston
CSV
cat > users.txt <<'TXT'
alice:Engineering
bob:Sales
charlie:Engineering
dana:HR
evan:Sales
TXT
cat > password-policy.txt <<'TXT'
PASSWORD POLICY (training document, not a real policy)
- Minimum 12 characters
- No reuse of the last 5 passwords
- Rotate every 90 days
- Never share passwords, never write them in files like secret.txt
TXT
printf 'red\nblue\nred\ngreen\nblue\nred\nyellow\ngreen\n' > duplicates.txt
cat > server.conf <<'TXT'
# Fake server config
ServerName copycat-lab
Port 8080
MaxClients 50
LogLevel warn
DocumentRoot /var/www/lab
TXT
cat > network.conf <<'TXT'
# Fake network config
interface=eth0
dhcp=true
dns=127.0.0.11
search=copycat.lab
TXT
printf 'the launch code is not here. try harder.\n' > secret.txt
awk 'BEGIN{for(i=1;i<=5000;i++) printf "line %d: the quick brown fox jumps over the lazy dog\n", i}' > large-file.txt

# ---------- logs (deterministic pseudo-random) ----------
cd "$H/logs"
awk 'BEGIN{srand(42)
  split("200 200 200 200 301 304 403 404 404 500",st," ")
  split("/ /index.html /login /admin /api/users /images/logo.png /robots.txt /secret",pa," ")
  split("GET GET GET POST",me," ")
  for(i=0;i<600;i++){
    printf "10.0.%d.%d - - [05/Oct/2026:%02d:%02d:%02d +0000] \"%s %s HTTP/1.1\" %s %d\n",
      int(rand()*4), int(rand()*250)+1, int(i/30), int(rand()*60), int(rand()*60),
      me[int(rand()*4)+1], pa[int(rand()*8)+1], st[int(rand()*10)+1], int(rand()*9000)+200}}' > access.log
awk 'BEGIN{srand(7)
  split("INFO WARN ERROR ERROR DEBUG",lv," ")
  split("connection reset by peer|disk usage at 91%|failed to open config|timeout talking to db|user login ok|cache miss|permission denied: /srv/data",ms,"|")
  for(i=0;i<300;i++) printf "2026-10-05 %02d:%02d:%02d [%s] %s\n", int(i/13), int(rand()*60), int(rand()*60), lv[int(rand()*5)+1], ms[int(rand()*7)+1]}' > error.log

# ---------- Documents / Downloads / Projects / hidden ----------
echo "Meeting notes: nothing important was decided."          > "$H/Documents/notes.txt"
echo "TODO: learn find, grep, sed, awk."                       > "$H/Documents/todo.txt"
echo "Shopping: milk, eggs, coffee"                            > "$H/Documents/shopping.txt"
echo "Not really a PDF." > "$H/Downloads/report.pdf"
echo "Not really a zip." > "$H/Downloads/installer.zip"
mkdir -p "$H/Projects/website" "$H/Projects/scripts-demo"
printf '<html><body><h1>Hello</h1></body></html>\n' > "$H/Projects/website/index.html"
printf 'body { color: black; }\n'                       > "$H/Projects/website/style.css"
printf '#!/bin/bash\necho "hello from demo"\n'          > "$H/Projects/scripts-demo/hello.sh"
echo "You found a hidden file. Try: ls -la" > "$H/hidden/.you-found-me"
echo "dotfiles are just files whose names start with a dot." > "$H/hidden/.README"

# ---------- scripts that give the process lab something to chew on ----------
cat > "$H/scripts/busywork.sh" <<'S'
#!/bin/bash
# Harmless background job. Find it with: ps aux | grep busywork   Stop it with: kill <pid>
while true; do date >> /tmp/busywork.log; sleep 5; done
S
cat > "$H/scripts/slow-counter.sh" <<'S'
#!/bin/bash
# Counts forever, slowly. Try: pgrep -a slow-counter ; killall slow-counter.sh
i=0; while true; do i=$((i+1)); echo "$i" > /tmp/slow-counter.out; sleep 2; done
S
cat > "$H/scripts/hello.sh" <<'S'
#!/bin/bash
echo "Hello, $USER! Today is $(date +%A)."
S
chmod +x "$H"/scripts/*.sh

# ---------- search lab: nested dirs with needles ----------
S="$H/labs/04-search/haystack"
for a in alpha beta gamma; do for b in one two three; do for c in x y; do
  mkdir -p "$S/$a/$b/$c"; echo "file in $a/$b/$c" > "$S/$a/$b/$c/note.txt"
done; done; done
echo "NEEDLE: find me with grep -R NEEDLE"  > "$S/beta/two/y/needle.txt"
head -c 3000 /dev/zero | tr '\0' 'z'         > "$S/gamma/three/x/big.dat"
touch "$S/alpha/one/x/empty.txt"

# ---------- permissions lab ----------
P="$H/labs/06-permissions"
mkdir -p "$P/shared"
echo "practice file"         > "$P/project.txt"
echo "secret plans"          > "$P/secret.txt"
printf '#!/bin/bash\necho it ran\n' > "$P/script.sh"
echo "admins only"           > "$P/admin-only.txt"
chown alex:developers "$P/project.txt"
chown root:admins "$P/admin-only.txt"; chmod 640 "$P/admin-only.txt"
chown copycat:students "$P/shared"; chmod 2775 "$P/shared"

# ---------- archives lab ----------
A="$H/labs/12-archives"
mkdir -p "$A/to-compress"
for i in 1 2 3 4 5; do seq 1 200 > "$A/to-compress/data$i.txt"; done

# ---------- disks lab: disposable files for dd ----------
D="$H/labs/13-disks"; mkdir -p "$D/scratch"
echo "Use dd on files in ~/labs/13-disks/scratch only. Example: dd if=/dev/zero of=scratch/blob bs=1M count=10" > "$D/scratch/README"

# ---------- ownership ----------
chown -R copycat:copycat "$H"
# permissions-lab files keep their special owners (re-apply after the blanket chown)
chown alex:developers "$P/project.txt"; chown root:admins "$P/admin-only.txt"
