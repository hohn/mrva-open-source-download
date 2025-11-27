#!/bin/sh
set -eu

LOGICAL="logical"
SHARDED="sharded"
MAP="shard-map.txt"

errors=0

while read -r ORG SHARD; do
    link="$LOGICAL/$ORG"
    expected="../$SHARDED/$SHARD/$ORG"

    # verify symlink target
    target=$(readlink "$link")
    if [ "$target" != "$expected" ]; then
        echo "ERROR: symlink mismatch for $ORG:"
        echo "  expected: $expected"
        echo "  actual:   $target"
        errors=$((errors+1))
        continue
    fi

    # verify inode identity for all files under logical/org
    find "$link" -type f | while read -r lf; do
        real=$(readlink -f "$lf")

        ino_logical=$(stat -c %i "$lf")
        ino_real=$(stat -c %i "$real")

        if [ "$ino_logical" != "$ino_real" ]; then
            echo "ERROR: logical inode mismatch:"
            echo "  logical: $lf ($ino_logical)"
            echo "  real:    $real ($ino_real)"
            errors=$((errors+1))
        fi
    done

done < "$MAP"

if [ $errors -eq 0 ]; then
    echo "OK: logical tree resolves correctly to sharded (all inodes match)"
else
    echo "FAILED: $errors errors found"
fi
