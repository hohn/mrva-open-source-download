#!/bin/sh
usage="
sh bin/shard_allocator.sh > shard-map.txt

sh bin/hardlink_mirror.sh
"
set -eu

ORIGINAL="repos"
SHARDED="sharded"
MAP="shard-map.txt"

# Ensure shard directories exist
mkdir -p "$SHARDED"
for i in $(seq 0 4095); do
    printf -v hex "%03x" "$i" 2>/dev/null || hex=$(printf "%03x" "$i")
    mkdir -p "$SHARDED/$hex"
done

while read -r ORG SHARD; do
    src="$ORIGINAL/$ORG"
    dst="$SHARDED/$SHARD/$ORG"

    echo "Mirroring $src → $dst (hardlinks for files)"

    # replicate directory structure
    find "$src" -type d | while read -r d; do
        rel=${d#"$src"/}
        mkdir -p "$dst/$rel"
    done

    # hardlink all files
    find "$src" -type f | while read -r f; do
        rel=${f#"$src"/}
        ln -f "$f" "$dst/$rel"
    done
done < "$MAP"
