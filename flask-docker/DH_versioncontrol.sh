#!/bin/bash

if [[ -f .env ]]; then
  export $(cat .env | grep -v '^#' | xargs)
fi

repository=$1

tagsJson=$(curl -sX GET -u "${DOCKER_USERNAME}:${DOCKER_PASSWORD}" "https://registry.hub.docker.com/v2/repositories/${repository}/tags?page_size=100" | jq -r '.results[].name')

readarray -t tags <<< "$tagsJson"

if [ ${#tags[@]} -gt 9 ]; then
  sortedTags=($(printf '%s\n' "${tags[@]}" | sort))
  oldestTag=${sortedTags[0]}
  digest=$(curl -sI -u "${DOCKER_USERNAME}:${DOCKER_PASSWORD}" -H 'Accept: application/vnd.docker.distribution.manifest.v2+json' "https://registry.hub.docker.com/v2/${repository}/manifests/${oldestTag}" | awk '/Docker-Content-Digest/ {print $2}' | tr -d $'\r')
  curl -X DELETE -u "${DOCKER_USERNAME}:${DOCKER_PASSWORD}" "https://registry.hub.docker.com/v2/${repository}/manifests/${digest}"
  echo "Image $repository:$oldestTag removed from Docker Hub"
fi
