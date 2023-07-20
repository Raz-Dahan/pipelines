#!/bin/bash

if ! command -v jq &> /dev/null; then
    echo 'jq is not installed. Installing jq...'
    sudo apt install jq -y
    echo 'jq has been installed.'
fi

echo 'Getting Chart.yaml...'
echo "
apiVersion: v2
name: flask-chart
version: 1.$BUILD_NUMBER
description: A Helm chart for deploying Flask and Redis" > Chart.yaml

echo 'Getting values.yaml...'
REPO='razdahan31/flask-k8s'
TAG=$(curl -s "https://hub.docker.com/v2/repositories/${REPO}/tags" | jq -r '.results[0].name')
echo "
VER: $TAG
RLS: 0.1.$BUILD_NUMBER" > values.yaml
