#!/bin/bash

echo 'Performing cleanup on local Docker images...'
echo 'Removing images if there are more than 5...'
IMAGES_SUM=$(sudo docker images | tail -n +2 | wc -l)
OLDEST_BUILD=$(sudo docker images --no-trunc --format '{{.Repository}}:{{.Tag}}' | tail -n +2 | sort -V | head -n 1)
if [ "$IMAGES_SUM" -gt 5 ]; then
    sudo docker rmi "$OLDEST_BUILD"
else
    echo 'No need to delete the oldest build. Total image count is less than or equal to 5.'
fi

INSTANCE_NAME="test"
PROJECT_ID="named-signal-392608"
ZONE="us-central1-a"
COMMANDS="
echo 'Performing cleanup on test instance Docker images...'
echo 'Removing images if there are more than 5...'
IMAGES_SUM=\$(sudo docker images | tail -n +2 | wc -l)
OLDEST_BUILD=\$(sudo docker images --no-trunc --format '{{.Repository}}:{{.Tag}}' | tail -n +2 | sort -V | head -n 1)
if [ "\$IMAGES_SUM" -gt 5 ]; then
    sudo docker rmi \"\$OLDEST_BUILD\"
else
    echo 'No need to delete the oldest build. Total image count is less than or equal to 5.'
fi"

gcloud compute ssh --project=$PROJECT_ID --zone=$ZONE $INSTANCE_NAME --ssh-flag="-o UserKnownHostsFile=/dev/null -o CheckHostIP=no -o StrictHostKeyChecking=no" --command "$COMMANDS"
