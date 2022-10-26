#!/bin/bash

REPOROOT=$(git rev-parse --show-toplevel)

declare -a arr=($(az repos list | jq -r '.[].sshUrl'))

for i in "${arr[@]}"; do
	"$REPOROOT/bash/EnvSetup.sh" "$i" DataEngineering
done
