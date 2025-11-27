#!/bin/sh
set -eu

ORIGINAL="repos"
SHARDED="sharded"
MAP="shard-map.txt"

errors=0

while read -r ORG SHARD; do
    src="$ORIGINAL/$ORG"
    dst="$SHARDED/$SHARD/$ORG"

    # directories under original
    find "$src" -type d | while read -r d; do
        rel=${d#"$src"/}
        [ "$rel" = "$d" ] && rel="."   # top-level
        d2="$dst/$rel"

        if [ ! -d "$d2" ]; then
            echo "ERROR: missing directory: $d2"
            errors=$((errors+1))
        fi
    done
done < "$MAP"

if [ $errors -eq 0 ]; then
    echo "OK: directory structure mirrored correctly"
else
    echo "FAILED: $errors errors found"
fi
