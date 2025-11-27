#!/bin/sh
set -eu

ORIGINAL="repos"
SHARDED="sharded"
MAP="shard-map.txt"

errors=0

while read -r ORG SHARD; do
    src="$ORIGINAL/$ORG"
    dst="$SHARDED/$SHARD/$ORG"

    # verify all files under $src have same inode under $dst
    find "$src" -type f | while read -r f; do
        rel=${f#"$src"/}
        f2="$dst/$rel"

        if [ ! -e "$f2" ]; then
            echo "ERROR: missing mirrored file: $f2"
            errors=$((errors+1))
            continue
        fi

        ino1=$(stat -c %i "$f")
        ino2=$(stat -c %i "$f2")

        if [ "$ino1" != "$ino2" ]; then
            echo "ERROR: inode mismatch:"
            echo "  $f  ($ino1)"
            echo "  $f2 ($ino2)"
            errors=$((errors+1))
        fi
    done
done < "$MAP"

if [ $errors -eq 0 ]; then
    echo "OK: repos → sharded inode mirror is 100% correct"
else
    echo "FAILED: $errors errors found"
fi
