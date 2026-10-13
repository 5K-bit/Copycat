# Lab 19 — Shell scripting  (about 20 min)

**Goal:** write a small bash script with an argument, a condition and a loop, and run it.

**Start here:** `cd ~/scripts`

## Steps

1. Read an existing script, run it two ways:
   ```
   cat hello.sh
   ./hello.sh
   bash hello.sh
   ```
   The first line, `#!/bin/bash`, says which program should run the file.
2. Create your own. This writes the file for you (the quotes around `EOF` matter):
   ```
   (the last `EOF` must start at the very beginning of its line):
```
cat > greet.sh <<'EOF'
#!/bin/bash
name=${1:-friend}
echo "Hello, $name"
if [ -f /etc/hostname ]; then
  echo "I am running on $(hostname)"
fi
for i in 1 2 3; do
  echo "count $i"
done
EOF
```
3. Make it executable and run it:
   ```
   ./greet.sh
   chmod +x greet.sh
   ./greet.sh
   ./greet.sh Sam
   ```
   The first run is `Permission denied`: a file is not a program until it has `x`.
4. Exit codes:
   ```
   ./greet.sh; echo $?
   false; echo $?
   test -f /nonexistent; echo $?
   ```
   0 means success. Anything else is a failure.
5. Make the script react to input. Append a check to the end of `greet.sh` with `nano greet.sh`
   (see lab 20) or with this (again, `EOF` flush left):
```
cat >> greet.sh <<'EOF'
if [ "$1" = "root" ]; then
  echo "no root here"
  exit 1
fi
EOF
./greet.sh root; echo $?
```

## Check yourself
- What is the difference between `$1` and `$@`?
- Why is `[ -f /etc/hostname ]` written with spaces inside the brackets?
- What is the difference between `"$name"` and `$name` when the value contains spaces?

## Challenge
Write `~/scripts/count.sh` that takes a folder as its first argument and prints how many
files are in it. If no argument is given, it should print a usage message and exit with code 1.

## Done
```
copycat-done 19
```

Broke something? Run `copycat-reset` on your PC (not in here).
