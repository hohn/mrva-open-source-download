#!/bin/sh
usage="
sh bin/shard_allocator.sh > shard-map.txt
"
set -eu

ORIGINAL="repos"
SHARD_COUNT=4096

hash_org() {
    # compute lower-case hex sha256 and return first 3 chars
    printf "%s" "$1" | sha256sum | cut -c1-3
}

# Generate mapping
# Format:  ORG  SHARD
for org in "$ORIGINAL"/*; do
    [ -d "$org" ] || continue
    org_name=$(basename "$org")
    shard=$(hash_org "$org_name")
    echo "$org_name $shard"
done
