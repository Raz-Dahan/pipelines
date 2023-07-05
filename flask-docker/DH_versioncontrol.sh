#!/bin/bash

repository=$1

tagsJson=$(curl -sX GET "https://registry.hub.docker.com/v2/repositories/${repository}/tags?page_size=100" | jq -r '.results[].name')

readarray -t tags <<< "$tagsJson"

if [ ${#tags[@]} -gt 10 ]; then
  sortedTags=($(printf '%s\n' "${tags[@]}" | sort))
  oldestTag=${sortedTags[0]}
  docker rmi "${repository}:${oldestTag}"
fi
