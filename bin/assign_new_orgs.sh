#!/bin/sh
set -eu

MAP="shard-map.txt"

hash_org() {
    printf "%s" "$1" | sha256sum | cut -c1-3
}

./detect_new_orgs.sh | while read -r ORG; do
    SHARD=$(hash_org "$ORG")
    echo "$ORG $SHARD" >> "$MAP"
    echo "Assigned org $ORG to shard $SHARD"
done

