#!/bin/sh
set -eu

ORIGINAL="repos"
MAP="shard-map.txt"

# Create a set of known orgs
awk '{print $1}' "$MAP" | sort > /tmp/known_orgs.txt

# List current orgs
ls "$ORIGINAL" | sort > /tmp/current_orgs.txt

comm -13 /tmp/known_orgs.txt /tmp/current_orgs.txt
