#!/bin/bash

REPOSITORY=$1
USER=$(echo "$REPOSITORY" | cut -d '/' -f1)
REPO=$(echo "$REPOSITORY" | cut -d '/' -f2)

TAGS_JSON=$(curl -sX GET https://registry.hub.docker.com/v2/repositories/$REPOSITORY/tags?page_size=100 | jq -r '.results[].name')
TAGS_SUM=$(echo $TAGS_JSON | wc -w)
HUB_TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d "{\"username\": \"$DOCKER_USERNAME\", \"password\": \"$DOCKER_PASSWORD\"}" https://hub.docker.com/v2/users/login/ | jq -r .token)
echo "curl -s -H "Content-Type: application/json" -X POST -d "{\"username\": \"$DOCKER_USERNAME\", \"password\": \"$DOCKER_PASSWORD\"}" https://hub.docker.com/v2/users/login/ | jq -r .token"
if [[ $TAGS_SUM -gt 10 ]]; then
  OLDEST_TAG=$(echo $TAGS_JSON | awk '{print $NF}')
  curl -i -X DELETE \
  -H "Accept: application/json" \
  -H "Authorization: JWT $HUB_TOKEN" \
  https://hub.docker.com/v2/namespaces/$USER/repositories/$REPO/tags/$OLDEST_TAG
  echo "The tag $OLDEST_TAG removed successfully"
else
  echo "There are no more than 10 tags"
fi

