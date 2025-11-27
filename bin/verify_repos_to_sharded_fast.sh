#!/bin/sh
set -eu

ORIGINAL="repos"
SHARDED="sharded"
MAP="shard-map.txt"

errors=0

while read -r ORG SHARD; do
    src="$ORIGINAL/$ORG"
    dst="$SHARDED/$SHARD/$ORG"

    echo "Checking $ORG"

    # Produce: inode path
    find "$src" -type f -printf "%i %P\n" |
    while read -r ino rel; do
        f2="$dst/$rel"
        if [ ! -e "$f2" ]; then
            echo "ERROR: missing mirrored file: $f2"
            errors=$((errors+1))
            continue
        fi

        ino2=$(stat -c %i "$f2")
        if [ "$ino" != "$ino2" ]; then
            echo "ERROR: inode mismatch for $ORG/$rel"
            errors=$((errors+1))
        fi
    done
done < "$MAP"

if [ $errors -eq 0 ]; then
    echo "OK: repos → sharded hardlink inodes match"
else
    echo "FAILED: $errors errors found"
fi
