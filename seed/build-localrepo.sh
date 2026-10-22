#!/bin/bash
# Build the tiny offline package repository used by lab 36 (/srv/localrepo).
# cc-lib 2.0 is the dependency; cc-widget 1.0 needs cc-lib >= 2.0.
set -euo pipefail
repo=/srv/localrepo
work=$(mktemp -d)
mkdir -p "$repo"

mkpkg() { # name version depends body
  local name=$1 ver=$2 dep=$3 body=$4 d="$work/$1_$2"
  mkdir -p "$d/DEBIAN" "$d/usr/bin"
  {
    echo "Package: $name"; echo "Version: $ver"; echo "Architecture: all"
    echo "Maintainer: Copycat Lab <lab@copycat.invalid>"
    [ -n "$dep" ] && echo "Depends: $dep"
    echo "Description: Copycat lab 36 practice package ($name)"
  } > "$d/DEBIAN/control"
  printf '#!/bin/sh\n%s\n' "$body" > "$d/usr/bin/$name"
  chmod 755 "$d/usr/bin/$name"
  dpkg-deb --build --root-owner-group "$d" "$repo/${name}_${ver}_all.deb" >/dev/null
}

mkpkg cc-lib 2.0 "" 'echo "cc-lib 2.0"'
mkpkg cc-widget 1.0 "cc-lib (>= 2.0)" 'echo "widget ok"'

cd "$repo"
apt-ftparchive packages . > Packages
gzip -kf Packages
apt-ftparchive release . > Release
rm -rf "$work"
