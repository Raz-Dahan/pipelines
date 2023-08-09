#!/bin/bash

if ! command -v jq &> /dev/null; then
    echo 'jq is not installed. Installing jq...'
    sudo apt install jq -y
    echo 'jq has been installed.'
fi

echo 'Getting Chart.yaml...'
echo "apiVersion: v2
name: nasa-app
version: 1.$BUILD_NUMBER.0
description: A Helm chart for deploying Flask and Redis" > Chart.yaml

echo 'Getting values.yaml...'
REPO='razdahan31/nasa-app'
TAG=$(curl -s "https://hub.docker.com/v2/repositories/${REPO}/tags" | jq -r '.results[0].name')
echo "TAG: $TAG" > values.yaml
