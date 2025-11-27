#!/bin/sh
set -eu

ORIGINAL="repos"
SHARDED="sharded"
MAP="shard-map.txt"

while read -r ORG SHARD; do
    src="$ORIGINAL/$ORG"
    dst="$SHARDED/$SHARD/$ORG"

    [ -d "$src" ] || continue

    echo "Mirroring $ORG → $dst"

    mkdir -p "$dst"

    # replicate directories
    find "$src" -type d | while read -r d; do
        rel=${d#"$src"/}
        mkdir -p "$dst/$rel"
    done

    # hardlink files (overwrite links if needed)
    find "$src" -type f | while read -r f; do
        rel=${f#"$src"/}
        ln -f "$f" "$dst/$rel"
    done

done < "$MAP"
