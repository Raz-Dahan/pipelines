#!/bin/bash

IMAGE=$1

echo "Performing cleanup on local Docker images..."
echo "Removing images of '$IMAGE' if there are more than 5..."

BUILDS_SUM=$(docker images "$IMAGE" | tail -n +2 | wc -l)
OLDEST_BUILD=$(docker images --no-trunc --format '{{.Repository}}:{{.Tag}}' "$IMAGE" | tail -n +2 | sort -V | head -n 1)

if [ "$BUILDS_SUM" -gt 5 ]; then
    docker rmi "$OLDEST_BUILD"
    echo "Removed oldest build: $OLDEST_BUILD"
else
    echo "No need to delete the oldest build for '$IMAGE'. Total image count is less than or equal to 5."
fi
