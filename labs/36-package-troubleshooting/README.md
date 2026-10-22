# Lab 36 — Package troubleshooting  (about 30 min, graded)

**Challenge:** repair a broken package installation (unmet dependencies).

## Concepts
- Debian/Kali packages are `.deb` files; **dpkg** installs/inspects them one at a time, **apt** resolves dependencies from repositories.
- A package whose dependencies are missing is left half-installed ("unconfigured").
- Tools: `dpkg -l`, `dpkg -s PKG`, `dpkg -L PKG`, `dpkg --audit`, `apt-cache policy PKG`, `apt-get -f install`, `apt-get check`.

## Warm-up
```
dpkg -l | head -5
dpkg -s bash | head -5
dpkg -L bc | head
apt-cache policy bc
```

## Graded challenge
```
copycat-setup 36
```
Copycat installs a practice package, `cc-widget`, on top of a missing dependency using `dpkg -i --force-depends`
(what happens when someone ignores a dependency error). A tiny offline repository (`/srv/localrepo`) contains the missing piece.
1. See the damage: `sudo dpkg --audit`, `dpkg -s cc-widget`, `sudo apt-get check`.
2. Read what it is missing from the status or error messages.
3. Repair it with apt (`sudo apt-get -f install`), password `copycat`.
4. Prove it works: `cc-widget` prints `widget ok`.

Then:
```
copycat-check 36
```

## Check yourself
- Why can `dpkg -i` install a package with missing dependencies while `apt install` refuses?
- What does `apt-get -f install` ("fix broken") do?
- How would you find out which package owns the file `/usr/bin/cc-widget`? (`dpkg -S`)

## Done
Score 100 in `copycat-check 36`, or `copycat-done 36`.
