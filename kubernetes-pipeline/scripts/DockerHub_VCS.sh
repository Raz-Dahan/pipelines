#!/bin/bash

REPOSITORY=$1
USER=$(echo "$REPOSITORY" | cut -d '/' -f1)
REPO=$(echo "$REPOSITORY" | cut -d '/' -f2)

export $(cat .env | xargs)

echo 'Remove oldest tag if there are more than 10 on Docker Hub...'
while true; do
  TAGS_JSON=$(curl -sX GET https://registry.hub.docker.com/v2/repositories/$REPOSITORY/tags?page_size=100 | jq -r '.results[].name')
  TAGS_SUM=$(echo $TAGS_JSON | wc -w)
  if [[ $TAGS_SUM -gt 10 ]]; then
    HUB_TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d "{\"username\": \"${DOCKER_USERNAME}\", \"password\": \"${DOCKER_PASSWORD}\"}" https://hub.docker.com/v2/users/login/ | jq -r .token)
    OLDEST_TAG=$(echo $TAGS_JSON | awk '{print $NF}')
    curl -i -X DELETE \
    -H "Accept: application/json" \
    -H "Authorization: JWT $HUB_TOKEN" \
    https://hub.docker.com/v2/namespaces/$USER/repositories/$REPO/tags/$OLDEST_TAG
    echo "The tag $OLDEST_TAG removed successfully"
  else
    echo "There are no more than 10 tags"
    break
  fi
done