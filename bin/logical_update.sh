#!/bin/sh
set -eu

LOGICAL="logical"
SHARDED="sharded"
MAP="shard-map.txt"

mkdir -p "$LOGICAL"

while read -r ORG SHARD; do
    target="../$SHARDED/$SHARD/$ORG"
    ln -sfn "$target" "$LOGICAL/$ORG"
done < "$MAP"
