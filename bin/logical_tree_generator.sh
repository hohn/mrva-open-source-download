#!/bin/sh
set -eu

SHARDED="sharded"
LOGICAL="logical"
MAP="shard-map.txt"

mkdir -p "$LOGICAL"

while read -r ORG SHARD; do
    target="../$SHARDED/$SHARD/$ORG"

    echo "Linking logical/$ORG → $target"

    # create symlink for org
    ln -sfn "$target" "$LOGICAL/$ORG"
done < "$MAP"
